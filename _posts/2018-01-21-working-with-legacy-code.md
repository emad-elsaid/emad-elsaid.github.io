---
title: "Working With Legacy Code"
date: 2018-01-21T22:02:46+01:00
---

Legacy code is everywhere, It doesn't matter if the project code is there for 20
years or 5 years, if it's not maintainable, or if it doesn't follow a clear
architecture, if there are not tests for it, then it's legacy.

Probably you already worked with one or more legacy project throughout your
career, the following are the steps I take to deal with legacy code in my
day-to-day work.

## Cleanup the project

Delete everything that you don't need in that project, any empty directories,
any files that are not used anywhere, any method that is not called anywhere,
search your whole project for forgotten pieces that was useful one day but it's
not needed anymore.

That include reviewing your dependencies and make sure all of them are used
somewhere, if you're using some web framework that follows MVC make sure that all
controllers are linked to a route, that it's not just sleeping there forgotten
after removing a route.

Review all your assets and make sure it's used, every image and CSS and
JavaScript file in there must be executed when the project runs.

## Testing

I get the code coverage for the whole project and make a plan to cover the reset
of it with tests, what's important for me is that the whole project runs in
tests, that If I removed one part of these files a test should fail, it doesn't
have to be unit test, but a test for the project features overall should exist,
running everything under it.

## Small refactoring

Make sure all classes public interfaces are used outside of the class itself, if
it's not used then hide it as a private method.

Rename methods and classes to follow some naming convention.

Move files around for better grouping, for example if you found a controller
concern that should be a helper file then do it, if there is a model that should
be a service then do it, small code movement without changing the business logic
of your application.

The list goes on with small refactors, the gist is move stuff around without
changing the business logic or making any risky changes.

## Write more unit tests

Now that project structure is in place, write more unit tests, make sure that
the units you have now are doing what it should do, exhaust your units logic at
this step, you're trying to test every unit, use the black box kind of tests,
don't bother yourself with implementation details, just give it some input and
tests outputs and side effects, basically what the units should do not how it
does it.

## Make big refactoring

That include everything you love, from applying [SOLID
principles](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) to
splitting your monolith into separate micro services, it's all yours, but I keep
in mind that I don't do all of it at the same time, I take one principle and
apply it everywhere to the code, and if possible I write a test of a
documentation page to make sure this rules is clean for other maintainers and it
wouldn't be broken in the future, after I apply that principle I move on to the
next one.

## Optimizations

After the previous step your project becomes maintainable -hopefully- :) then
the optimizations step comes in place, in that step I employ some caching
layers, rewriting some parts so that it becomes faster, micro benchmarking and
tiny optimizations.

## Finally

It's always good to document whatever you applied to the project and make it
easily accessible to other project maintainers, a wiki page is not enough, you
have to give it the correct labels/tags, link it to the readme in the appropriate
section, also a README file for every directory is a good idea, as it tells new
maintainers why is this directory there and what should it he use it for and the
rules governing that directory classes/modules.
