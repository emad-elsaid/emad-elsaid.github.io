---
title: Single Machine Startup Company System (Part 2)
---

In the [last post](/single-machine-startup-company-system) I presented a simple
way to build a single machine system for a small startup. The system will have
many users and teams and services running for each team some of them are
internet facing.

I want to explore this idea further more. I want to make this system/company
independent of any other company as much as possible. I want this single machine
to have the software needed for internal use of this company.

Think about this:

* If we can run services on this server machine and it's only accessible from
  inside the server itself
* Only our team members can access services inside the server
* We can use SSH to open a SOCKS5 proxy connection from local machine to this
  server.
* Our local programs can use SOCKS5 to access the services inside this system.

This means we can do this:

* Start IRC server inside this server that listen on **127.0.0.1:6667**
* User can open SOCKS5 proxy `ssh -D 8888 -q -C -N user@server`
* Then use IRC client on their machine to connect to `companyname.tld:6667`
  proxying through `127.0.0.1:8888` port.

This Implies:

* Users has to have access to the server to connect to the service (IRC) in this
  case
* If one of the users left the organization locking his account will lock him
  out of all the services at the same time.
* the organization control the service and all it's data
* users can use services inside the system to complement their system, like if
  one service depend on the other they can develop one on their machine and let
  it connect to te other service inside the machine.

This concept can be used to run some services as an alternative to popular
applications startups are using nowadays:

* IRC server for chatting instead of Slack
* MediaWiki as a replacement for Confluence for example
* OpenProject instead of Jira/Asana/Trello
* **Use it as git server**, on the server create a directory for the project then
  `git init --bare` then add it as a remote on your machine
  `user@server.ip.address:/path/to/directory` then you can push/pull/branch
  it'll act like github just without a UI


**Note:** You can have an OpenVPN server running instead of using SOCKS5 proxy.
