---
title: Replacing Golang Regexp matching with a premitive faster solution
image: /images/IMG_20201220_112919.jpg
image_alt: Grunwald forest, Berlin, Germany
---

On [who is popular today.com](https://www.whoispopulartoday.com) I have a
service called *tagger* it's job is to get new news records and find people
names in it, then creates a record that makes the relation between this news
article and the person found in this article.

An example is an RSS article titled:

```
خالد الصاوي يرفض طلبا لـ أبلة فاهيتا على الهواء ويكشف سبب فصله من المدرسة
```

The tagger should create 2 relation records one for each person in this list:

- خالد الصاوي
- أبلة فاهيتا

The service works this way:

- Gets all people names from the database 800,000 of them
- Get new articles
- For each article it tries to find each of these 800k names and return the list
  of names found
- For each name it creates a record (articles ID, Person ID) to the DB.

And There are some preparations for all text that get into this process

- Cleaning the text: to remove Emojies and anything that's not a character and
  replace it with a space
- Normalize the text: converting some characters that's usually misspelled
- People names has to be sorted by longest first as one person can be the father
  of another and the father name is included in the son full name, so to match
  with the son not the father name we need the longest to be found first and
  removed then the son name.

## The problem

If you have a nem like **عادل إمام** the previous process will find the name in
articles similar to this:

```
الأهلى يتعادل أمام الزمالك 1-1
```

The problem here is the characters matches but it's not a name really. But if I
tried to find the name only surrounded by spaces that will miss names with
prefixes like:

```
يتصدر الأعلى مشاهدة عبد الفتاح السيسي وعادل إمام فخالد الصاوي
```

So names can be still refixed with a character so I have to match the name with
and without prefixes prefixed with space or in the beginning of the text and
followed by a space or at the end of the text, that seems like a regular
expression right?

```go
name := "person name here"
prefixes := []string{"prefix1", "prefix2", "prefix3"}
reg = regexp.MustCompile(fmt.Sprintf("(\A|[[:space:]])(%s)?%s(\z|[[:space:]])",
strings.join(prefixes, "|"), name))
```

Then we can use the `reg.FindString()` and `reg.ReplaceAllString()` to find the
matches and replace them when found.

Given we have 800k names that means for each article we'll need to match with
all of them, THAT WAS VERY SLOW compared to `string.Contains` and
`string.ReplaceAll` so I had to find a faster solution.

## The solution

First lets simplify this regex, with a little twist to the input we can get rid
of `\A` and `\z` if our string always has a space in the beginning and at the
end.

```go
[[:space:]](%s)?%s[[:space:]]"
```

also `[[:space:]]` matches spaces, new lines, carriage return, line feed
characters, but we already cleaned and normalized all strings so we have only
spaces, so I can simplify it to this

```
\s(%s)?%s\s
```

This is still really slow, so I had to expand it to it's possibilities

so assuming we have 3 prefixes:

- ف
- و
- ل

we can so the following variations of the name:

- عادل إمام
- فعادل إمام
- وعادل إمام
- لعادل إمام

and that would be a slice of strings that we can deal with them with the usual
method we had `strings.Contains` and `strings.ReplaceAll` which is way faster
that the regexp methods.

so this 800*4k strings find and replace is faster than 800k regexp find
and replace.
