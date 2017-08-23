---
title: Integerating Jekyll and Octopress in Emacs
date: 2016-02-23T21:30:44+01:00
---

I started using emacs couple weeks ago and i have to say that i'm amazed by how
this editor is working, Emacs VS VIM war isn't coming from nowhere after all.

one thing that annoys me is that i stopped blogging for a long time, if you checked the last
blog post, it's been a year since the last one.

so I had an idea, what if i made blogging more comforting for me? maybe integerating my
blogging platform (jekyll + octopress + git) to Emacs, aaaand there was a problem,
the current jekyll (hyde.el) looks weired to me that i couldn't even try to use it.

I started writing my own integeration, to create a post and publish it I can write simple
functions to execute these command from Emacs into my blog directory, that's not so hard right?

nooooo, for a ELisp noob like me it's like hell, i had to Google how to define a variable,
see? it's hell, and i was stuck for a while untill i knew that `C-x X-e` doesn't evaulate
the whole buffer, yeah, I'm a total noob.

after a lot of sweat, blood and WTF moments i implemented 3 methods:

1. the first one `octopress-post` is to create new post interactively and open the generated file in Emacs.
2. `octopress-dir` to open `_posts` directory, for fast access to posts and so.
3. `octopress-build-and-deploy` to build the blog with jekyll then deploy it with octopress to github pages

the 3 functions are simple implementation, you should not expect much from my Elisp code, it's a simple
straight forward implementation and there is a lot of room for enhancements.

This post is the my first post from Emacs, Hope it works, wish me luck,

Oh I forgot, here is my code, I just pasted it to my `~/.emacs` and execute it with `M-x RET <function-name>`

```elisp

(defvar octopress-path "/Users/emad/bitbucket/blazeeboy")
(defun octopress-post (post-name)
  (interactive "sNew post name: ")
  (message "Creating new post: %s" post-name)
  (defvar post-path
    (shell-command-to-string
     (concat "cd " octopress-path "; octopress new post " post-name)
     )
    )
  (find-file-existing (trim-string post-path))
  )

(defun octopress-dir ()
  (interactive)
  (find-file-existing
   (concat octopress-path "/_posts"))
  )

(defun octopress-build-and-deploy ()
  (interactive)
  (async-shell-command (concat "cd " octopress-path "; jekyll build; octopress deploy"))
  )

;;; third party code
;;; http://ergoemacs.org/emacs/modernization_elisp_lib_problem.html
(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
  )
```
