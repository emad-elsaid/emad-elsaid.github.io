---
title: "Consistency Over Creativity"
date: 2018-01-14T17:58:40+01:00
---

Consistency is doing the same thing in the same way everytime, in software
engineering it means using same design pattern to accomplish the same task no
matter who is doing the task or when he's doing it.

For example if you're developing a new task, always looks for similar tasks
that was done before, seek out the implementation, and do your new tasks in a
similar way, use same directory structure, same naming convention, same
patterns.

It's easy to get dragged in a creative hole where you want to do this design
pattern, or that abstraction layer, the final result is a good part that doesn't
fit in the whole body, and you end up with different abstractions implemented by
different people in a single project.

## Benefits of consistency

when you have multiple ways of doing the same thing, that leads to confusion,
it's a cognitive overhead that you don't need if you're joining a new project,
you shouldn't ask yourself, should I do it this way or that way? maybe if you're
the one adding that pattern it feels logical and intuitive but for other people
joining your project it's not, especially if there are 3 or 4 different ways to
do the same task in the same project.

and I assure you it felt logical and intuitive for other developers when they
introduced that new pattern to the project, just as you feel.

So consistency makes it easier for any contributor to understand that codebase
and dive into contribution faster.

It also increase the maintainability of the project, because no matter who's
doing the task, there is one way to do it and there is no room for confusion or
misunderstanding.

## When to be creative

there are 2 situations where I find creativity is useful:

* When you have a new project and you're making design decisions
* When you're doing a totally new task that doesn't have similar sister before
* When you're refactoring, you can be creative an decide how to restructure that
  part of your code, but also you have to apply your new pattern everywhere in
  your code, don't leave loose tails.

So in general, keep your code consistent that will extend your project lifetime
for good.
