---
title: Download RSS Offline
---

Couple weeks ago I changed my workflow regarding reading/sending emails. So to
have more control over my emails I started using
[offlineimap](http://www.offlineimap.org/) which can download your emails
offline to a directory on your filesystem. I then used
[Mu](https://www.djcbsoftware.nl/code/mu/) which index this directory so you can
search for emails offline using some queries, like "show me unread emails from
inboxes" or you can search for a word in all your emails from all inboxes. Over
all of that I used [Mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html) which
is an email client inside Emacs (my default editor). As I'm using
[Spacemacs](https://www.spacemacs.org/) So I added a binding that opens Mu4e
using `SPC M` and boom I can see all my emails, I can search with `s` and I have
a bookmark that shows all unread emails using `bi`.

Now I want the same for RSS.

Here is the problem, I made some research and couldn't find similar tools that
does the same for RSS, although it would be easier, there are no authentication
required like IMAP/SMTP servers, So I spent an hour or so writing a small script
that does the same as `offlineimap`, this script on my machine is called
`offlinerss`, it's the first piece of the puzzle and it looks like that

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'
require 'open-uri'
require 'fileutils'
require 'digest'
require 'yaml'

gemfile do
  source 'https://rubygems.org'
  gem 'rss'
end

def mkdir(*paths)
  path = File.join(*paths)
  FileUtils.mkdir(path) unless Dir.exist?(path)
  path
end

destination = mkdir(File.expand_path('~/rss/'))
inbox = mkdir(destination, 'INBOX')
meta_dir = mkdir(destination, '.meta')

config_file = File.join(destination, 'config.yml')
config = YAML.load_file(config_file)
urls = config['urls']

urls.each do |url|
  url_digest = Digest::SHA1.hexdigest(url)

  URI.open(url) do |rss|
    content = rss.read
    feed = RSS::Parser.parse(content)

    feed.items.each do |item|
      id = item.respond_to?(:id) ? item.id : item.guid
      id_digest = Digest::SHA1.hexdigest(id.content)
      file_basename = url_digest + '-' + id_digest + '.xml'

      next unless Dir.glob(File.join(destination, '**', file_basename)).empty?

      filename = File.join(inbox, file_basename)
      File.write(filename, item.to_s)
    end

    [{ start_tag: '<entry>', end_tag: '</entry>' }, { start_tag: '<item>', end_tag: '</item>' }].each do |tag|
      next unless content.include?(tag[:start_tag])

      content[content.index(tag[:start_tag])...(content.rindex(tag[:end_tag]) + tag[:end_tag].length)] = ''
    end

    metafile = File.join(meta_dir, url_digest + '.xml')
    File.write(metafile, content)
  end
end
```

I have a small config file in `~/rss/config.yml` which has all the URLs I care
for, so far just ruby/rails/go main blogs to be alerted by the latest versions.

```yaml
urls:
   - https://server.tld/feed.rss
   - https://server.tld/feed.atom
```

This just reads the URLs, and saves each entry to a file on your machine
`~/rss/INBOX` if the file doesn't exist in any sub directory in `~/rss`. Then it
removes all entries/items from the feed and save the rest to `~/rss/.meta`.

The file names of the RSS item is `sha1(url)-sha1(item.id).xml`  and the meta
file name is `sha1(url).xml` very simple.

So now I need to write a client that reads files in `~/rss/` and render the XML
files and some actions to create directories under `~/rss/` and actions to move
the file to another directory after it's read or the user want to move it to
`read-later` or something, just like emails directories.

Another piece of the puzzle is indexer like what `Mu` does for the emails.

I was surprised that it was easy to just sit down and write the thing for myself,
than searching for days for a solution.
