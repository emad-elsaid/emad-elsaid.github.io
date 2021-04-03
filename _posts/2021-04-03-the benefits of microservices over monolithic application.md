---
title: The benefits of microservices over monolithic application
image: /images/IMG_20210310_134315.jpg
---

It's a common discussion when implementing a new set of features whether to have it as part of an existing application or to split it in another process/codebase. So in this post I'll record the benefits of microservices that I think of when this conversation is brought up.

First when I have to say what the term "Microservices" means to me to make sure we're talking about the same thing.

What I mean by microservices is organizing a system in :

- Small code bases that takes one or two people a week or so to build
- Each runs in separate process probably in separate machines
- Their dependency on each other is planned, clear and well organized
- Their scope is mostly fixed and doesn't get bigger over time.

Having said that the benefits of this approach over any other is as follows:

## Easier to maintain

Facing a bug will be easier to fix. as spotting the service responsible for the error can be discovered from the logs of each service and having each service responsible for a clear small scope will make it easier to spot the service that needs to be fixed.

Fixing a small project that has 10 to 20 files of code and built over a week is way easier than fixing a project that has hundreds of files and dozen modules.

## Easier to rewrite

As the turn over of startups is high. there is always a time where new developers reject the old code out of complexity. Having the service built by one or two people over a week makes it easier to re-implement by any new developers if they wish. lowering the cost of renewing parts of the system with a new programming language or a new algorithm is easier as the service scope is fixed.

## Easier to try new programming languages

As the service takes one or two people a week that means they can use any programming language they want. as in the future if new developers doesn't know this language or doesn't like it means they can easily re-implement it in a short period of time.

## Changing the ownership

As the organization restructure and evolve and expand we need to redefine teams boundaries and responsibilities. having the code split to smaller services as described makes it easier to move services ownership between teams. that's nearly impossible to do when maintaining monoliths without significant restructuring.

## Enforced boundaries

Having the code in one monolithic codebase makes it tempting to reach for any module and use it ignoring the structure or the project for the uninformed developer. Having codebases separate means using another part of the codebase an explicit decisions with realized consequences.

## Faster to retire

As the system evolve some services loses its benefit and is doomed to be retired. it's easier to shutdown a service that's not needed anymore. just turn off the process and archive the codebase. in monolithic implementations that is way too complicated. it involved untangling parts of the code and deleting modules and making sure no other module is assuming the existence of that part of the code. it's a mess.

## Easier to develop parts of the system independently

As each codebase is separate. two teams can develop two different parts of the system without stepping on each other toes. just agree on a contract/API/Interface and each of the teams can go and develop their services.
