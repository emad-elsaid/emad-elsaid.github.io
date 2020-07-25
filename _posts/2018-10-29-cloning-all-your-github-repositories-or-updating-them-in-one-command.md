---
title: "Cloning All Your GitHub Repositories or Updating Them in One Command"
date: 2018-10-29T21:04:15+01:00
---

I had a new laptop couple weeks ago at work, and I had to set it up with
everything I need including the projects I have been working on from GitHub, I
remembered how I usually `git clone` every project I start working on, it
involves going to GitHub to the project page, copy the clone URL then I go to my
terminal, `cd` to the projects directory and executes `git clone
http://github.com/org/repo`.

But what if I don't need to do that, What if I just cloned all the repositories
at once and update them all with one command, that could save a lot of time when
I have a new machine or I came back from a long vacation and I want to update
all the machines.

The implementation is pretty trivial, I should connect to GitHub API and get the
list of repositories for me or the organization I want to clone, iterate over
every repo and clone or update it, and because GitHub doesn't return all
repositories in one page I have to repeat that process until I get an empty
page.

The following snippet does that, it needs some dependencies like `tty-prompt`
and `colorize` both can be removed, but I like to have colored text and
menus for that script.

```ruby
#!/usr/bin/env ruby
require 'tty-prompt'
require 'open-uri'
require 'json'
require 'colorize'
require 'colorized_string'

prompt = TTY::Prompt.new

user_name = prompt.ask("What is name of the user or organisation?")
type = prompt.select("What type is it?", user: "users", organisation: "orgs")
token = ENV['GITHUB_API_TOKEN']

unless token
  puts "Can't find GITHUB_API_TOKEN in you environment!".light_red
  puts "Use the follow URL to generate a token: https://github.com/settings/tokens".light_red
  puts "Then add it to your .bashrc/.bash_profile/...etc as a variable GITHUB_API_TOKEN".light_red
  exit
end

page = -1
loop do
  page += 1
  url = "https://api.github.com/#{type}/#{user_name}/repos?access_token=#{token}&page=#{page}"
  repos = open(url).read
  repos = JSON.load(repos)
  break if repos.empty?

  repos.each do |repo|
    if Dir.exist?(repo["name"])
      puts "Updating #{repo["name"]}...".light_blue
      Dir.chdir(repo["name"]) do
        system("git pull --all")
      end
    else
      puts "Cloning #{repo["name"]}...".light_blue
      system("git clone #{repo["ssh_url"]}")
    end
  end
end
```
