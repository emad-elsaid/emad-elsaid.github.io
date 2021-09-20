---
title: How do I prototype my ideas
image: /images/IMG_20210918_153641.webp
---

It's usual for me to get ideas for programs. while reading a book or watching YouTube or going for a walk. If the idea is too exciting for me I sit on my laptop or PC and start writing it within couple hours I get something up and running. Here is what goes in my mind while I'm implementing these ideas.

# Drop all community standards

First I ignore all community standards and what's called **best practices**. in order to hit the target of the idea I need to move forward with the least baggage possible. this means the single most important thing is to have a script/program that runs and produce the result I want. that's all what matters to me right now.

if it's a web server then I use something like Sinatra. Write a hello world server and replace hello world with a layout that uses a CSS framework from a CDN and start writing the part that's really important for me. the minimum code that results in the idea.

# Commit in every step

If I have something that runs and produce the results then I commit it. doesn't matter if it's good or bad, if it works then it'll be recorded in the Git history. there is no charge for commits and it saves me from the risk of messing up my code accidentally AND I can continue to work on the same project on another machine if I do this regularly and push to GitHub.

# Whatever I do I don't leave the program broken

Whenever I sit down and improve the program I do it in small incremental improvements. after each improvement I commit and push it. like a checkpoint in a game. And I never leave a program broken. the point is if I checkout a commit I should be able to run it.

So now I have a program that works and I improve it in tiny steps. it works in every step and I can do it from multiple machines.

This also means if I lost interest in the idea the implementation can be continued by someone else. it's on GitHub to anyone can clone and improve it slightly and open a pull request.

# Target guideline I aim for in my improvements

I aim for reducing dependencies all the time. I replace each dependency with the piece of functionality that I need to my specific program. usually dependencies are covering a wide range of use-cases and my program is mostly use one or two use-cases so I implement exactly what I need and save myself the extra dependency.

Less code. this part contradict the previous point artificially but deep down it aligns. so removing a dependency reduces the overall code your program depends on but makes the codebase of your program itself larger. And what I want is to have less code overall. So what I do is look for places where I was over engineering or covering use-cases that doesn't exist, like a function argument or a class or a function that shouldn't exist or an abstraction that's not needed like a function used only once or a class that has one method...etc

The idea is simplify the program and have exactly the code that it needs to deliver the features without over coding or any unnecessary abstractions.

# I try to cover the use-cases that I need first

Most of the time I'm writing programs that I need. So most of my effort is to deliver the features that I use myself. not a feature that's cool or requested by another person. And as I'm committing my changes all the time. any other person that needs it can work on it in parallel.

# Back to the community standards

While doing the gradual improvements this is the time to judge the code state if there are any issues you need to solve with a community standards/best practices. there is no medal or a prize to write your program in a way that follows common linters rules or in a specific way that people think of as optimal. what you may get is that other people will be more familiar with the code style which may lead to more pull requests with improvements. this case surprisingly rare. most open source programs are really deserted programs so in most cases you'll be the only coder and many users uses your program. so I make sure that I am comfortable with what I write than imposing some coding style that other people like.
