---
title: "Async Rendering a Page With Sinatra"
date: 2018-10-28T14:30:04+01:00
---

I was thinking, what if you need a server that serves a page that does alot of
processing, it sends multiple commands, does alot of queries and most of them
takes a long time.

Waiting for all commands to finish isn't an option, fast response time is also a
requirement, so a solution could be warming up a cache then render the page from
this cache.

That solution means you will also wait for all commands/queries to finish then
respond with you output.

But do we have to wait to either wait for all of them? what if we can render
what's done and ignore the rest, and when we render the page again maybe other
commands/queries are finished so we render them and so on until we try to
request the page one time and all queries are done so we'll render the full
page.

I think this isn't a new idea, I vaguely remember a ruby framework that does
this Async widgets but can remember the name at all, maybe it was introduced in
one of the ruby/rails conferences/talks.

The solution I came up with is straight forward, the interface for you should be
a method that you can passing a block and a default value, that method will
execute that block, if the block takes a long time it'll return the default
value until one time that method is executed while requesting the page and it'll
return the block return value.

That solution require us to execute the block in a non-blocking wait, so to do
that let's create a new thread for that block.

Now you have a thread running in the background, the method when called again
should have a track of what blocks created and what's not, so a cache has to
exist for each block you try to execute, and whenever this method is called it
creates or gets the output of the block.

The solution will allow you to render each part of the page asynchronously, as
the interface is simply a method call taking a block.

The following gist may show you how this could be implemented, it's a simple
Sinatra server, that renders the output of `ps` executed on a remote server,
when the page is rendered the block will be sent to the background and the page
will be empty, and when you refresh the method call will return the output if
the block finished

{{< gist emad-elsaid c059b48191bde7030f34aa77b35bc304 >}}
