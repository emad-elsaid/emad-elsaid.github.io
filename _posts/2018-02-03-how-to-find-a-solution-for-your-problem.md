---
title: "How to Find a Solution for Your Problem"
date: 2018-02-03T21:41:47+01:00
---

1. Open [Google.com](https://www.google.com/)
2. Google your problem
3. Open all links in the first page
4. Read page by page until you find a solution
5. If your problem still exists, back to number 2

-----

For more clarification please refer to the following graph

![googling graph](/images/googling_graph.png)

## Exercise

The previous image is generated from the following DOT graph, try to find how to
generate the same png image from it on your machine.

```
digraph google {
  google [label="Open google.com"]
  search [label="Search for your problem"]
  openlinks [label="open first page links"]
  read [label="read results"]
  solved [label="problem solved?"]
  end [label="Congrates"]

  google -> search -> openlinks -> read -> solved
  solved -> end [label="yes"]
  solved -> search [label="no"]
}
```

Congrates, you solved your problem, good job.
