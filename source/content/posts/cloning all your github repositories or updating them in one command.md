---
title: "Cloning All Your GitHub Repositories or Updating Them in One Command"
date: 2018-10-29T21:04:15+01:00
---

I had a new laptop couple weeks ago at work, and I had to set it up with
everything I need including the projects I have been working on from GitHub, I
remembered how I usually `git clone` every project I start working on, it
involves going to GitHub to the project page, copy the clone URL then I go to my
terminal, `cd` to the projects directory and executes `git clone
http://github.com/org/repo`.

But what if I don't need to do that, What if I just cloned all the repositories
at once and update them all with one command, that could save a lot of time when
I have a new machine or I came back from a long vacation and I want to update
all the machines.

The implementation is pretty trivial, I should connect to GitHub API and get the
list of repositories for me or the organization I want to clone, iterate over
every repo and clone or update it, and because GitHub doesn't return all
repositories in one page I have to repeat that process until I get an empty
page.

The following snippet does that, it needs some dependencies like `tty-prompt`
and `colorize` both can be removed, but I like to have colored text and
menus for that script.

{{< gist emad-elsaid a2a1cd6cd81c8802defc19259d59525f >}}
