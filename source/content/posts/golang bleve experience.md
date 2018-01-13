---
title: "Golang Bleve Experience"
date: 2018-01-13T15:32:48+01:00
---

I have a search engine for people profiles coming from wikipedia stored in my
site, every person may have an english name or arabic name and also bilingual
excerpt (the first 2 paragraphs about him from his wikipedia page),


so I started my full text search engine, used golang and blevesearch package, in
the beginning my search results were not up to my expectation, as I was storing
name + excerpt as one text,

so even if the person name is in the beginning of the text it doesn't contribute
to his order in the results, so it shows 10th or even 15th in the list of
results.


next I tried to store names only, and it worked better, way better that the name
show in the beginning (as it's an exact value so makes sense), but I found
another problem,

now I need to show the person and any one else related to him, and by related to
him I mean his name mentioned in their excerpt.


so the usual solution is have the excerpt indexed as a separate field and
continue to search on all fields, but I went back againg to the first problem,
the order is incorrect.


so I even tried to have an index for all fields (name, excerpt) but search only
on names, and I was surprised that it didn't give me the correct results, it
sounded like bleve searched in all fields

although I instructed the routine to search only names.

so I reverted to the other solution, just have the index for names, and search
only names, that perfect results if you're looking for person by name, but it's
incorrect if you're searching for people

by job description or something else in their excerpt.
