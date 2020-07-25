---
title: "Representing Named Entity Mention in Postgres for Fast Queries"
date: 2018-12-14T22:17:39+01:00
---

For the past 3 years I have been working on a side project called
www.whoispopulartoday.com, it's specialized in collecting news and analyzing it
to find public figures mentions and build analytics on it, in that article I'll
walk through the evolution of representing the relation between the entities
(people figures) and the news (tweets, fb posts, YouTube videos and rss
articles).

# Technology stack

I'm a backend developer so most of the solution is heavy on the backend and
lighter on the frontend, but as we'll talk now about the "mentions"
implementation I'll talk only about the backend part, the tools I used were:

1. Postgres
2. Ruby on Rails
3. Docker
4. Go

# How did it start

In most of my side project I tend to build stuff on my own, it gives me more
knowledge, that using ready made solutions, so for my first implementation I had
everything implemented in one Ruby on rails project connecting to the database,
and some background jobs using clockwork gem to get news and analyze them.

The solution looks good until I felt the code-base is getting bigger than it
should be, so I split them to a `crawler` and `website`, 2 projects now, one of
them had a read-only access to the database, serves the pages and keeps it
simple, does most of the stuff on the server side, and uses foundation for
styling, G2 for charts ( it used to use D3 but I found that Alipay G2 is
faster).

Now lets talk about the crawler part, it used to do a lot of stuff:

1. syncing people profiles with Wikipedia
2. getting news from twitter, Facebook, rss feeds, YouTube
3. crawling websites for open graph images for people without images on
   Wikipedia
4. analyzing news text and linking them with people names

# The linking part

So it's a simple idea, to see if someone is mentioned in a news article you can
do the following:

1. get people names, all of them in a list
2. get the article you want to link with
3. iterate over all names and see if the text contains that name, if so `create
   mention` (more is coming later on that part)

That can be represented in that database with the following:

1. auto increment ID
2. person id
3. news id

But keep in mind that you need to account for the future, just a little so you
don't lock yourself, and not too much so you don't fall into the premature
optimization hell, so lets assume we'll have `places` along with `people` in the
future, and maybe also `organizations`, so instead of `person id` lets use a
polymorphic relation, so the structure become like that:

1. ID
2. entity ID
3. entity type
4. news id

There is another problem here, that news are not one type, we have 4 types
(YouTube videos, rss articles, tweets, Facebook posts), so `news id` should also
be polymorphic relation

1. ID
2. entity ID
3. entity type
4. source ID
5. source type


With that structure you can know what are the entities mentioned in a source, or
if you have a person you can get sources that mention him.

Here is a problem, how do you get number of news per day in that case for a
person (entity)? joining with the source can't be done in an easy way now,
you'll have to marge 4 tables together and then merge it with that table on
`source id` and `source type` to get that information, that will get extremely
expensive with more data.

there is a simple solution here, whenever you're creating a mention add the
source creation time to it so your table would look like this:

1. ID
2. entity ID
3. entity type
4. source ID
5. source type
6. created_at

In that case you can get number of news for a person per day, a simple query on
one table.

The problem you'll face in that case is that this query needs to be faster, over
a big data set any query will be slower unless you put some indices in the right
place and the right order in some cases, in our case here you'll need to add an
index for the entity id + entity type as a composite key, so filter down with an
entity id and name (that's always the case, you never query with the entity ID
alone).

The problem here is that an index over `entity type` will still be slow,
indices over string columns perform slower that on numerical columns, but in our
case we're lucky enough, as `entity_type` will have a small set of values, the
classes names of the entities (Person, Place, Organization), converting that
table into an enum will make it much faster, also while you're at it do the same
thing to the `source ID` and `source type`.

With that structure you'll be able to do queries over time period, grouping by
day/minute/second/months/years...etc.

Now lets look at the big picture:

1. We have many countries
2. Every country has many Newspapers
3. Every Newspaper has many News sources (twitter accounts, Facebook
   pages...etc)
4. Every News source publishes many News Items
5. Every News Item mentions many Entities


Now lets think of some elaborate queries and how we can do that with our
mentions table.

# Top newspapers publishing about a person in the last month scoped by a country

Here is the problem, with the `mentions` table now you can't even filter down
mentions by country, you have to join on the sources tables the join that with
sources accounts tables (Facebook pages, twitter accounts ..etc) that join them
with newspapers table and finally you get the country id from the newspapers
table, that's a lot of work, sooooo what if we just added the `newspaper_id` and
the `country_id` to the `mentions` table? wouldn't that make it easier? now we
can filter down mentions by country or by newspaper of both.

For our query we can filter down by country ID and a person ID + type and by a
creation time the group it by the newspapers and count the records

```sql
SELECT count(*) AS frequency
FROM mentions
WHERE entity_id = ?
AND entity_type = ?
AND created_at BETWEEN ? AND ?
AND country_id = ?
GROUP BY newspaper_id
ORDER BY frequency DESC
LIMIT 10
```
A simple query done on one table, now look at the where clause in that query and
see what indices we need :D `country_id` and `created_at`.

now that query can work fast on that one table, notice also that all the values
we use in that table now are numerical but only one column is a timestamp
`created_at` which is in some sense also numerical with special properties to
it, that makes the size and processing of that table very fast, and as our
operation to that table is 99% additions it rarely collects garbage and doesn't
need vacuuming.

# Number of news per day for a specific person for the past month

you get the idea, it's even simpler, the following snippet of ruby may give you
an idea how to do it:

```ruby
inner_query = entity
  .mentions
  .select("DATE(mentions.created_at + interval '#{timezone} seconds') AS day, count(*) AS frequency")
  .where(created_at: date_range, country: country)
  .group('day')
  .to_sql

connection = Mention.connection
result = connection.execute(%{
SELECT DATE(date) as date, coalesce(frequency,0) AS frequency
FROM generate_series(
DATE(#{connection.quote(start_day.to_date)}),
DATE(#{connection.quote(end_day.to_date)}),
'1 day') AS date
LEFT OUTER JOIN (#{inner_query}) results
ON (date = results.day)
ORDER BY date
})
```

the problem that snippet solves is the days without news or where the person
wasn't mentioned at all, then suddenly the newspapers mentions him, so I get the
stats for the days he's mentioned in first then join it with another query that
generate days in the required period.

That can be done partially by the database engine then augmented with a ruby
code that generate the days array and merge with the result, but I found
delegating all the work to the database engine is way faster so I ended up with
that nested query here, but still works on one table though.

Also a side note here that I found using 2 where clauses for limiting the
`created_at` value is faster that the `BETWEEN` statement, no idea why it's just
how it is.


# Caching every where

Ruby is known to be slow, so caching has to go everywhere, in some cases I case
a hash of `newspapers_id -> newspaper_name` that's useful when I have to render
a news article and I have the newspaper ID but I don't want every time to get the
newspaper record from the database, so I had to pull all the records from the
database and cache them in memory, that allowed me to resolve newspapers ID to
names in constant time without and IO blocking.

Other caching had to be done for the previous queries, as even if the query is
slow, a hammering of visits can destroy the server, so a 3ms query done by
potentially 100 visitors per second and you have 300ms query, if you doing 30 or
them per page you'll be facing a 9000ms latency at worst, that's a 9 seconds.

So the solution is always cache stuff `between requests` mostly:

1. database results
2. partial views

# The current state of the Mentions after 3 years in production

That table now holds around 5.1 Million records, queries are performing well
without any noticeable latency over time, the data belongs to 22 countries, 1
type of entities and 4 types of news.

# The state of the crawler

Over time I realized that the `crawler` application should be split into smaller
pieces, so I extracted the news analyzer into a Golang service I call it the
`tagger` as it tags the news with people names, all it does is to poll the
database for new news and create mentions for people mentioned in these news.

Also tried to create a service that has a cache of some analytics of the
mentions table, like number of news per day for a specific country, it polls the
database news tables for new records, keeping an index of country news count
separated by news type, that gives me the number of tweets for the day for that
country, and number of fb posts, also number of RSS items...etc, you get the
idea, also useful to get total number of posts for that country per day over a
period of time, Go has proved to be really fast and easy to maintain, I
basically wrote it once and didn't touch it for couple months now.

# Conclusion

That system is kinda my experiment, I sink my free time in it and I proved
myself couple point by it so far:

1. You don't have to use fancy ETL tools to process data
2. The simpler the system the easier to maintain
3. Less dependencies works way better (I have a check while I'm deploying to
   force me to update dependencies if it's outdated)
4. Ruby is slow but it's my friend when I need to write something in a short
   amount of time, and if it's small enough I can rewrite it in Go if it survived.
5. You don't have to hire an army of developers to get a system like that
   working and evolving
