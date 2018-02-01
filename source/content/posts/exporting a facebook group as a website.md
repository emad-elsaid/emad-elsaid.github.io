---
title: "Exporting a Facebook Group as a Website"
date: 2018-02-01T22:26:12+01:00
---

For couple of years I have been honored by administrating a large Facebook
group, it has over 15K Egyptian developers, it's been there for a while, people
are posting quality content, asking and answering questions all the time,
writing articles specific to Egypt and other related topics, which is a great
journey to have.

Facebook for a long time turned its back on groups, the interface was buggy and
slow, no new features were introduced regularly, that changed for the past
year, they started addressing issues, adding minor features like filters for
join requests, and major features like group analytics.

That makes you think of another way to have some degree of freedom for your
community when it comes to data analysis/search at least, so the following
approach felt logical to my case:

## Exporting Data Periodically

Facebook doesn't offer a feature to export your group posts so you have to use
Facebook graph API to pull as much data as you can.

For that I developed a small script with ruby to do it, it connects to Facebook
and pulls all posts from the group (it's a public group so all you need is
application access token), also pulls comments and reactions with every post,
and write a file for every post data encoded in some readable format, I choose
YAML for my script, also JSON would be a suitable choice for that purpose, just
avoid binary formats or formats that are bound by a specific programming
language.

[This GitHub repository](https://github.com/egyptian-geeks/posts) contains the
`download` script along with all 15k posts pulled from Facebook, also I setup my
private server to update the repository every day at midnight UTC+1, that keeps
the grunt work out of the way and you have an up-to-date data-set.

## A Web Application

That's the one of the ways you can use the exported data-set, the most straight
forward approach, pull all data to a database (even SQLite would suffice) and
display it in certain order or with certain criteria like number of comments,
likes, certain day or for a specific user.

Also aggregation over data would introduce another set of statistics that could
be displayed, like most active users, most commenting users, quality of posts
based on rules you prefer.

For that purpose I developed [this GitHub
repository](https://github.com/egyptian-geeks/website) to do that, it's a Ruby
on Rails project, that imports part of the data-set to an SQLite3 database, then
display posts in order or creation, it uses bootstrap to provide an
out-of-the-box experience, and to lower the bar to entry level developers to
contribute to it.

Also a Dockerfile was introduced in the repository, linking it with
hub.docker.com, so that an image is build with every push/merge to master
branch.

The docker image will be production ready, it pulls posts, import it to a
database, all assets are compiled and rails will run in production environment,
so the image could be pulled to a server or any machine with docker on it and
run it with one command, the usual docker experience right here.

## Next Steps

A lot could be done once you freed your data from the platform, the following are
some of the possible ideas:

- Sentiment analysis for posts and comments can lead to deep categorization
- Similarity detection, can group posts with same questions are repeated topic
- Real time search, I'm thinking of in memory store and can provide a blink of an
  eye response time experience

I feel that this is a door that has been opened and there is alot behind it, it
just needs some creativity and a willing to give back the community, and you can
make a pretty interesting platform here, and the best part of it that it doesn't
require your community members to leave Facebook at all, it's a side track for
whoever feels willing to see the community from a different angle.
