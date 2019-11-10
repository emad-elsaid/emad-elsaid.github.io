---
title: "Git as Messages Queue"
date: 2019-11-10T20:33:52+01:00
---

Hey, Good idea bad pitch, lets use Git as a messaging queue! lets use github to
synchronize a cluster of them together.

Lets get the obvious out of the way, You already know we use Git to keep track
of our code changes, and we need a central point to pull and push these changes,
this is why we use github/lab/bitbucket...etc.

Alright, now lets introduce another idea: Git commits doesn't need to include
changes, so you don't need to have to create files then commit these files to
your git repo, you can create an empty commit with a command like this

```
git commit --allow-empty -m "commit message"
```

OK, so the commit message can be any text right? that means you can have JSON
messages or YAML or any other machine readable format as a commit message.

So now imagine this scenario:

1. Create a repo on github
1. Clone it to your server
1. Have your application commit a `message` to this repo every time you need to
1. Push the repo every period say 10 seconds
1. Clone same repo to another server
1. Have an application there (consumer) pull periodically
1. Another thread there that checks for new commits and for each one of them
   extracts the message and does the job
1. Put a label on the processed message with that server identifier
1. Push that label to keep track of the last processed message (pull it when you
   deploy that consumer again)

Now you have a queue of messages that can't be altered, communicated between
servers and all data saved in a git repository.

This idea is flexible and can be modified for several use cases:

1. the central server doesn't have to be a github or a like, you can use your
   own server as a git server.
1. You can have more than one queue for messages by creating many branches each
   for a type of messages or a different messages purpose.
1. You can have the same branch consumed from different servers each message
   processed multiple times in different ways like RabbitMQ fan out strategy
1. You can keep browse your message queue with any git client UI or CLI
1. You can clean your servers git local repo so that it deletes old commit
   history to save space.
1. You can have many messages producers write to different branches in the same
   repository
1. In the future you can join 2 branches or split a branch and have your
   consumers adapt to that

This idea can as simple as invoking git commands from your application with a
system call, or use libgit to manipulate the repository for you, or even a small
server application that communicate over a socket, or a repo service that
communicate over even HTTP, there are so many ways to implement that concept.
