---
title: "Projects Files Flame Graph"
date: 2018-01-21T20:42:45+01:00
---

Flame graphs are graphs of stack of steps over each other they define a call
stack for an application over time, so an application probes your running
process periodically and stores the call stack, then draw a graph out of it
similar to the following:

![Flame graph](http://www.brendangregg.com/FlameGraphs/cpu-mysql-updated.svg "Interactive flame graph")

I have a project called [Dirtree](https://github.com/emad-elsaid/dirtree) it
takes a set of lines in `this/unix/style/path/format/to/file.ext` and output
interactive graph of these file paths, using this tool with `git ls-files` you
can see the whole project structure in one HTML page as a tree, similar to that

![Dirtree tree](/images/dirtree-tree.png)
![Dirtree tree](/images/dirtree-circles.png)

It's interactive graph that lets you dive into the whole project structure, it
helped me find unused files and clean my projects.

Last week I was looking into some other d3js graphs and found that the flame
graph is actually interesting, and it also display the same relation a tree does,
so I wonder if it could be helpful for dirtree to have a flame graph as one of
its outputs.

so I implemented the template for dirtree and it gave me output similar to this

![Dirtree tree](/images/dirtree-flamegraph.png)

It's a flame graph showing you all files in you project, first time I used this
graph on one of the projects I discovered a 5 years dead feature laying there
unnoticed.

My workflow is simple I generate a graph of my files with

```bash
git ls-files | dirtree -t flame -o /tmp/flame.html
open /tmp/flame.html
```

I look at the generated graph, navigate through it, then I spot some anomaly, a
directory that contains one file, or a directory that is too deep, or some files
that are named in a weird way, then I got to my editor and inspect these files,
most of the time I discover that these files shouldn't be there or could be
restructured in a better way, so I do it, then I repeat the process again.

dirtree is a ruby gem that could be installed with

```bash
gem install dirtree
```

it doesn't depend on any other gem and it outputs HTML file, so you can generate
that as part of your project documentation with some push hook to GitHub, it's
definitely useful tool that helped me a lot through the last couple months.
