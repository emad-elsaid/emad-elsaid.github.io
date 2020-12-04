---
title: The quest to collect all software man pages
image: /images/1607074760556.jpg
---

I used [Devdocs.io](https://devdocs.io/) for couple years now. I appreciate the
effort that went to this application. I use it for DOM, Ruby, HTTP, Rails and
others.

So I started to think about how hard could it be to do something similar for
Linux man pages. How hard is it to collect all Linux man pages and render them
in HTML and push them to the web. I see some website are already doing that but
they didn't get updated for some time now. the style and readability needs abit
of work.

Linux man pages are written in a typesetting language called **roff** Linux
comes with a tool **groff** to render it to other formats like PDF, ASCII, PS.
if you have a man page file and you want to render it in HTML for example you
can do that


```shell
groff -mandoc -Thtml /usr/share/man/man1/411toppm.1
```

which will convert it to HTML page and write to STDOUT.

The problem now is that we need all the man pages written for all software, this
is a quest that's hard to fulfill so I started by downloading all software in
the Archlinux repositories and extract their man pages from their pages.

Archlinux repositories are HTTP servers that we use them to download packages,
each server had different directory for different type of software like:

- core
- community
- extra

Each directory will have a **.db** file with the same name that has a list of
all software in the directory, their names and other meta information for
example **core/** directory has **core.db** file. it's a tar directory that you
need to extract and inside it there is a **desc** file with meta information for
each package.

The format of the **desc** file is nothing I have seen before, it's a text file
starts with a line of a label followed by a line for the value like

```
%FILENAME%
abcs.tar.gz
```

So I had to get all these files parse them and get the file name for each
package.

But as we don't need the whole package we just need the man files. Instead of
downloading the package to the disk I streamed it to `tar` and extracted only
files inside `usr/share/man/` to the disk. So I ended up with all the man pages
of all packages minus the files I don't need.

After that I converted all these man pages to HTML with **groff** and rendered
them with [jekyll](https://jekyllrb.com/). I wrote a simple layout that uses
[Bulma.io](https://jekyllrb.com/) and uploaded them to my server and served them
with nginx.

The really hard part for me was parsing all these files and discovering their
formats. they're not documented anywhere so I had to learn it through
experimentation.

The end results can be found here [Ag(1)](https://man.emadelsaid.com/ag.1/) This
is the man page of **Ag** silver searcher.

The side bar needed a bit of work as I had to use a fuzzy search JavaScript
library to filter the list of man pages. but as I ended up with more than 55000
manual pages I needed to ship all the man pages names and paths to the frontend
so I just wrote them in a text file and loaded them with Ajax when the page
loads.
