---
title: Why Am I Using KeePassXC?
image: /images/1605788191749.jpg
---

The following are the reasons for using KeePassXC as my Password Manager:

- It stores everything on my machine, so if anything is down it wouldn't matter, I have my passwords and everything related to it on my machine, In other cases like lastpass or 1password or roboform if their servers are down or the connection between my machine and their servers has something wrong with it, or some DNS problem I'm screwed, but if my data is on my machine there is no way I can't access them.

- It stores everything in a file, that means I can sync it between my machines, I can backup the file with simple unix tools, in other cases accessing my vault of passwords it just a nightmare of jumping through hoops and authentication, this is even if the service provide this kind of interface.

- It has TOTP, I used to use lastpass.com before, and having TOTP isn't supported, but with KeePassXC I can have the TOTP in the same place as my passwords so I don't need two applications for that it's just KeePassXC and Keepass for android application and I'm done, That also means I'm not bound to google authenticator application anymore and their limited way of controlling your TOTP tokens.

- It's open source, so in case I need to fix something or implement a feature I can just jump into the code and fix it then open a PR like any other open source application

- It has versioning so in case I changed the password for an account or want to get back to a note I added then deleted, everything is there and I can get back to it.
