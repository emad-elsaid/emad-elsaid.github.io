#sideproject 

I wanted to write my notes in text format. my options were:

* Web Service 
    * Google doc
    * Notion
* Application
	* One note
	* Obsidian
    * Typora
    * Emacs Org-Mode
  
# My preferences

- I wanted to have my notes on my machine. having all of my notes on remote server is a no go. 
- I wanted to be able to extend the solution
- Nothing complicated, it should be simple with no extra features I don't need
- Plain text format, binary data or custom formats lock my files to a specific solution

# Org-Mode

That eleminates everything but Emacs Org-Mode. And I tried it for a while. the main problem for me was that it's limited by emacs UI. so I can't include a video or audio and extending it require Knowing Elisp. I can do simple stuff in Elisp but the fact that Org-Mode is already complicated then extending it with a language I'm not very familiar with harder. 

So that drops even Org-Mode.

# Xlog

So I had to write my own solution. I choose #go for that. build a very simple core: 

- HTTP server 
- works on current directory
- has an interface that renders markdown to HTML
- has an interface to edit markdown files

Then I started to add every feature as one file to the project and structured it in a way that removing the file removes the feature.

Then I started to add some features like: 

- supporting hashtags
- converting any text to a link if it's a name of another note.
- list of recently edited files
- search
- support for emojis
- versioning

# Generating static files

- After couple months of development I made a video on youtube describing the program and that increased my interest in developing it again

https://www.youtube.com/watch?v=9dxhDo2F06k

- So I added a way to use the program in readonly mode
- and then used that develop a way to build the whole directory as HTML + extension pages.
- That allowed me to migrate my personal website (the one you're reading now) to more simple and flat structure. I was using github page default jekyll structure before.

# Main website

https://xlog.emadelsaid.com

# Github project 

The program is open source on github: 

https://github.com/emad-elsaid/xlog
