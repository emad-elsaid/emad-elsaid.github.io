So for the past weeks I have been improving this blog, For the past years I
learned a lot, and unlearned a lot also.

Some of the things I learned is to [keep it
simple](https://en.wikipedia.org/wiki/KISS_principle) that guided me to take a
lot of decisions.

Here I'll list the decisions I took to improve my blog website:

## Use Jekyll + GitHub pages

I was using Jekyll in the beginning then moved the Hugo for the performance it
promised, but I realized that I really don't need this performance, my blog
posts didn't exceed the hundred posts, plus I need to compile my website on my
machine before pushing the static content to GitHub pages.

My setup was to have the website source in a sub directory and compile the
website to the parent directory, that complicated things as you can imagine.

I realized using Jekyll and letting GitHub compile the website when I push the
post will be an easier workflow.

## Minimal theme

I searched Jekyll themes, I have to say that I was disappointed to see most of
them, so I picked the most minimal one and tried to clean it.

## No JavaScript

All themes as one way or another JavaScript, but thinking about the posts I
write I thought that I really don't need any JavaScript, everything I need can
be done with HTML and CSS, so I removed all JavaScript from my website.

## No tracking

I have to say it's taken for granted now that every website has crap tons of
tracking code, I block them myself with [ghostery](https://www.ghostery.com/)
google chrome extension, I thought that I never got any benefit from including
google analytics in my blog, never influenced my decisions on what to write and
what's not, so why am I including it at all? it doesn't matter if 10 people or
100 people visited my blog, It's irrelevant to what I publish on this blog, And
the tracker was the last bit of JavaScript on this blog, by removing it the
website will be JavaScript free, And so I did.

## No Custom CSS

I usually start my websites with a CSS framework, like bootstrap, Foundation or
Bulma, they provide me with a stepping stone that I can customize in the future,
recently I find Bulma was the most beautiful of them, So I'm using it for this
blog, I added some custom CSS and then thought that I really don't need any
customization I can just use bulma CSS classes in my HTML and that is
sufficient, If the users are here for the content then just put the content
there in a readable way, make sure it works on mobile (which it does by
default), and spare my visitors the extra custom CSS.

The only style that's not included in Bulma is the code highlighting, that I
couldn't get rid of, but I was able to inline it in the page, so to save the
extra HTTP request.

So the requests your browser will make to load this pages is one request for the
page itself, one for bulma CSS from the CDN, one for the favicon, and requests
for the blog images if it include images, no unneeded files, no tracking, no
bullshit code tracking your anymore, just the content you requests and a style
to make it readable.

## Full RSS content

I believe that the web lost a great application when google reader was shut
down, RSS is a great way to read content without all the bullshit websites are
attaching to the content nowadays, So RSS for me is out of question, my website
has to be able to publish the full content in RSS format, and it's displayed
prominently on the top of my website.

## No comments

I have seen so many people adding Disqus comments to their website, but Disqus
adds tracking to their pages, and you're inheriting all their decisions, so no
thank you, plus I noticed that the comments sections are less and less useful, I
never found the comments section in any website useful, instead I added two
buttons, one for sharing on Facebook and the other to twitter, when you share to
twitter you have a mention to my profile by default and that could be a start of
a discussion thread, that way you get notifications for replies and I get it
too, and you have more control over your comments than just including Disqus,
Also I get to clean my website from any tracking and keep it minimal.

## No pagination

As I said, my blog posts are not that many, So paginating them is not needed,
Also the index page only renders the title of each post, so even if these were
thousands it won't take too much traffic to load their title, and you get to
search for what you want in your browser, that's simpler than adding pagination
then adding another feature to search, if you already have the titles then you
can search for it yourself, and spare each other all the hassle that comes with
pagination.


## Conclusion

So this website:

- Doesn't have JavaScript
- Doesn't track you
- You can read it from RSS reader
- You can even read it from the terminal with any terminal browser
- You can can read it from Emacs `eww`
- You can find all posts titles in the home page and search for what you want
- [Hosted on GitHub](https://github.com/emad-elsaid/emad-elsaid.github.io) so you can even fork and suggest edits
