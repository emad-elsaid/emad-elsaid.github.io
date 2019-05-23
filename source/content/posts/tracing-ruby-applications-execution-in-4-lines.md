---
title: "Tracing Ruby Applications Execution in 4 Lines"
date: 2019-05-23T17:46:35+02:00
---

I was researching a simple way to trace ruby code, so the problem I tried to
solve (as usual) is to understand the code infront of me even more, so I need
some monitor, when I open a rails server and I navigate around, I need to see
the methods executed and where is it located, I need to see that in realtime.

Turns out the solution is very simple, as Ruby has `TracePoint` module, you can
use it to log any thing gets called in your application, so adding this snippet
to your rails initializers or anywhere before your application starts.

```ruby
TracePoint.new(:call) do |tp|
  puts "#{ tp.path }:#{tp.lineno}\t#{ tp.defined_class }\t#{ tp.method_id }"
end.enable
```

That should print every method call to your standard output, but you'll discover
early that everything is too much, you need to ignore method calls that doesn't
belong to your application code, like `puma` server method calls, or any
external gem calls, so lets limit it to our application by adding a suffix `if`
to the `puts` line.

```ruby
TracePoint.new(:call) do |tp|
  puts "#{ tp.path }:#{tp.lineno}\t#{ tp.defined_class }\t#{ tp.method_id }" if tp.path.include?('/app/')
end.enable
```

that should limit it to method calls located under `/app` directory, but as you
know your application also logs stuff, so it doesn't make sense to log to
STDOUT, lets separate that logs to a log file, and as my `/tmp` directory is a
`tmpfs` mapped to memory not SSD, it'll be fast and volatile, so I don't care to
clean it up afterwards.

And for that I'll createa a logger to a file in `/tmp` and use it to print these
executions

```ruby
logger = Logger.new('/tmp/trace.log', File::WRONLY | File::APPEND | File::CREAT)
TracePoint.new(:call) do |tp|
  logger.debug "#{ tp.path }:#{tp.lineno}\t#{ tp.defined_class }\t#{ tp.method_id }" if tp.path.include?('/app/')
end.enable
```

So now you can `tail -f /tmp/trace.log` to see your application execution in
realtime, but you'll learn also that you need to filter the logs or search in
them, so that can be done by piping your log file to `fzf` you can find it
[here](https://github.com/junegunn/fzf) so to see your logs and search through
them now you can execute this in your shell

```bash
cat /tmp/trace.log | fzf
```

If you want to have your whole screen filled with fzf and the input prompt to
the top you can add `--layout=reverse`

```bash
cat /tmp/trace.log | fzf --layout=reverse
```
