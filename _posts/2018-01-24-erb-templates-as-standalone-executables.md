---
title: "ERB Templates as Standalone Executables"
date: 2018-01-24T21:04:28+01:00
---

The following is a technique that can convert ERB files (Embeded Ruby) to
executable files like any other ruby/python/shell scripts, the difference is
that ERB is more suitable in cases where you have some output that needs to be
filled with data, like rails view files, or a text that needs to report number of
files/dependencies, in this post I will try to explore this idea.

first I created a file with this content

```erb
Today is : <%= Time.new %>
```

You can render the file with `erb` as it's command line tool to render `erb`
files and output the result to the terminal.

```shell
erb date.erb
```

will output something similar to the following
```
Today is : 2018-01-24 21:08:20 +0100
```

As Linux looks for [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) in
every executable file, then if this erb file given the executable permission and
prepended by a shebang for erb it will be executed nearly the same way but
without explicitly specifying erb in the terminal, so first rename the file

```shell
mv date.erb dateprinter
```

and give it the executable permission
```shell
chmod +x dateprinter
```

now prepend it with a shebang for erb, it should look like this now
```erb
#!/usr/bin/env erb
Today is : <%= Time.new %>
```

now it could be executed as follows
```shell
./dateprinter
```

the only difference is that the output will have the shebang line also, as ERB
doesn't parse it and consider it part of the template file.
```text
#!/usr/bin/env erb
Today is : 2018-01-24 21:08:20 +0100
```

if you put the previous file in a directory that is added to your shell `$PATH`
you can execute it from anywhere by it's name like any other executable file.
```shell
dateprinter
```

So in that case your shell will look for executable file in the path, will find
the dateprinter file, it'll try to figure out how to execute it with `exec` so
it'll inspect for magic bytes, it'll find the shebang, so it'll pass the file
to the appropriate interpreter `erb` and erb in that case will execute it and
hand you the output.

now lets do something useful with this idea, lets create a template that print
the number of dependencies for a rails application.

When you execute `bundle install` the last 2 lines looks like this

```text
Bundle complete! 27 Gemfile dependencies, 109 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

so to get the appropriate line we need to cut the output with `head` and `tail`
as follows
```shell
bundle --local | tail -n2 | head -n1
```

so the returned output will be similar to this
```text
Bundle complete! 27 Gemfile dependencies, 109 gems now installed.
```

now with ruby we can match the numbers in any string and extract them
```ruby
stats = `bundle --local | tail -n2 | head -n1`
numbers = stats.scan(/[0-9]+/)
direct_dep = numbers.first
indirect_dep = numbers.last
```

so an ERB file as the following can print out these stats, I added some
sprinkles on top

```ruby
#!/usr/bin/env erb
Project Name: <%= File.basename(Dir.pwd).capitalize %>
<% stats = `bundle --local | tail -n2 | head -n1`.scan(/[0-9]+/) %>
Direct Dependencies: <%= stats.first %>
Indirect Dpendencies: <%= stats.last %>
Direct Initializers:  <%= Dir.glob('config/initializers/*.rb').count %>
Initializers in Development Env: <%= `rake initializers`.lines.count %>
Initializers in Production Env: <%= `RAILS_ENV=production rake initializers`.lines.count %>
Controllers: <%= Dir.glob('app/controllers/**/*_controller.rb').count %>
Models: <%= Dir.glob('app/models/**/*.*').reject{|f| f.include?('concern') }.count %>
Views: <%= Dir.glob('app/views/**/*.*').count %>

<%
def files_for(ext)
  Dir.glob('**/*.' + ext)
end

def size_for(ext)
  files_for(ext).map{|f| File.size(f) }.inject(:+).to_i
end
%>
Assets:
JS: <%= files_for('js').count %> Files, <%= size_for('js') / 1024 %> KB
SCSS: <%= files_for('scss').count %> Files, <%= size_for('scss') / 1024 %> KB
PNG: <%= files_for('png').count %> Files, <%= size_for('png') / 1024 %> KB
JPG: <%= files_for('jpg').count %> Files, <%= size_for('jpg') / 1024 %> KB
```

The final output will look like this

```ruby
#!/usr/bin/env erb
Project Name: Web

Direct Dependencies: 27
Indirect Dependencies: 109
Direct Initializers:  5
Initializers in Development Env: 119
Initializers in Production Env: 117
Controllers: 10
Models: 16
Views: 65


Assets:
JS: 15 Files, 2569 KB
SCSS: 30 Files, 86 KB
PNG: 42 Files, 596 KB
JPG: 0 Files, 0 KB
```

Numbers will be different for your project.

## Generating Graphs

The following is my approach

1. a template that is interpreted by ERB to generate [DOT format](https://en.wikipedia.org/wiki/DOT_(graph_description_language))
2. pass the output to `dot` command to generate another format like `pdf` or
   `svg`

So lets try to have the same data visualized, first a simple graph, lets name it `rails-graph`
```text
#!/usr/bin/env erb
digraph graphname {
     a -> b -> c;
     b -> d;
}
```

executing this file with
```shell
rails-graph | dot -Tpng > graph.png
```

You should see the following

![basic graph](/images/erb-graph-1.png)

Now lets put more nodes and numbers to this graph

```ruby
#!/usr/bin/env erb
<%
stats = `bundle --local | tail -n2 | head -n1`.scan(/[0-9]+/)
ini = Dir.glob('config/initializers/*.rb').count
prod_ini = `RAILS_ENV=production rake initializers`.lines.count
dev_ini = `rake initializers`.lines.count
dev_mwares = `rake middleware`.lines.count
prod_mwares = `RAILS_ENV=production rake middleware`.lines.count

m = Dir.glob('app/models/**/*.*').reject{|f| f.include?('concern') }.count
v = Dir.glob('app/views/**/*.*').count
c = Dir.glob('app/controllers/**/*_controller.rb').count
routes = `rake routes`.lines.count - 1

def files_for(ext)
  Dir.glob('**/*.' + ext)
end
def count_for(ext)
    files_for(ext).count
end
def size_for(ext)
  files_for(ext).map{|f| File.size(f) }.inject(:+).to_i
end
%>
digraph graphname {
        direct_gems [label="Direct gems <%= stats.first %>"]
        indirect_gems [label="Indirect gems <%= stats.last %>"]

        initializers [label="<%= ini  %> initializers"]
        dev_initializers [label="<%= dev_ini %> Development initializers"]
        prod_initializers [label="<%= prod_ini %> Production initializers"]

        { rank=same; initializers dev_initializers prod_initializers }

        dev_middlewares [label="<%= dev_mwares %> Development middlewares"]
        prod_middlewares [label="<%= prod_mwares %> Production middlewares"]


        controllers [label="Controllers: <%= c %>"]
        models [label="Models: <%= m %>"]
        views [label="Views: <%= v %>"]

        routes [label="Routes <%= routes %>"]


        indirect_gems -> direct_gems -> initializers -> routes
        direct_gems -> dev_initializers -> dev_middlewares -> routes
        direct_gems -> prod_initializers -> prod_middlewares -> routes

        routes -> controllers

        controllers -> models
        controllers -> views

        js [label="JS: <%= count_for('js') %> Files, <%= size_for('js') / 1024 %> KB"]
        scss [label="SCSS: <%= count_for('scss') %> Files, <%= size_for('scss') / 1024 %> KB"]
        png [label="PNG: <%= count_for('png') %> Files, <%= size_for('png') / 1024 %> KB"]
        jpg [label="JPG: <%= count_for('jpg') %> Files, <%= size_for('jpg') / 1024 %> KB"]

        views -> assets
        assets -> js
        assets -> scss
        assets -> png
        assets -> jpg

}
```

The result will be as follows:
![basic graph](/images/erb-graph-2.png)
