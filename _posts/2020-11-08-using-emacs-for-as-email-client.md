---
title: Using Emacs as email client
image: /images/IMG_20200801_205147.jpg
image_alt: Engelbecken, Berlin
---

Couple months ago I decided to reduce the number of online services I'm using
and depend on my local machine setup, My local setup is linux on all machines
(Except for the gaming PC) so it would be possible to get rid of the Gmail
interface for example in favor or a local application.

As I depend on Emacs as an editor and other tasks I wanted to try using it as an
email client, The way I used was "Mu4e" which is a package that can read/send
emails from emacs interface, here is how I had this setup working.

# Downloading all emails locally with OfflineIMAP

Offline IMAP is a python program that can connect to many IMAP servers and sync
your emails from the IMAP servers to local machine directory. which means I'll
have all my email offline I can search, read and move them around like any other
file on the machine.

Offline IMAP is part of Archlinux community packages so install it with
```
sudo packman -S offlineimap
```

Then I needed to configure it to sync the emails to `~/mail` directory,
OfflineIMAP config file lives in `~/.offlineimaprc`, the content for me is as
follows

```conf
[general]
accounts = account1, account2
pythonfile = ~/path/to/mailpass.py
maxsyncaccounts = 2

[Account account1]
localrepository = account1-local
remoterepository = account1-remote
autorefresh = 5
postsynchook = mu index

[Repository account1-local]
type = Maildir
localfolders = ~/mail/account1

[Repository account1-remote]
type = Gmail
remoteuser = account1@gmail.com
remotepasseval = get_pass("~/.ssh/account1.gmail.password")
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
ssl_version = tls1_2

[Account account2]
localrepository = account2-local
remoterepository = account2-remote
autorefresh = 5
postsynchook = mu index

[Repository account2-local]
type = Maildir
localfolders = ~/mail/account2

[Repository account2-remote]
type = Gmail
remoteuser = account2@gmail.com
remotepasseval = get_pass("~/.ssh/account2.password")
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
ssl_version = tls1_2
```

This configuration uses a password encrypted in a file with my rsa private key,
that gets decrypted with a pythong function defined in `~/path/to/mailpass.py`

So I get an [application specific](https://myaccount.google.com/apppasswords)
password for my email account from my gmail account then I encrypt it to a file
like so:

```shell
echo -n "<password>" | openssl rsautl -inkey ~/.ssh/id_rsa -encrypt > ~/path/to/email.password
```

The `~/path/to/mailpass.py` is a python file that has one function it takes a
file path and decrypt it with openssl

```python
#! /usr/bin/env python2
from subprocess import check_output

def get_pass(file):
    return check_output("cat " + file + "| openssl rsautl -inkey ~/.ssh/id_rsa -decrypt", shell=True).splitlines()[0]
```

IMAP uses this `get_pass()` function to get the password, this is an alternative
to writing your password directly in the `.offlineimaprc` file.

Now running `offlineimap` command should pickup the configuration and start
syncing it to `~/mail`, this operation takes a long time depending on the number
of emails you have in your mail.

To make sure offlineimap runs everytime I login to my user account I enable and
start the systemd service that comes with offlineimap package

```shell
systemctl enable offlineimap --user
systemctl start offlineimap --user
```

You'll notice that offlineimap configuration we added this line
```
postsynchook = mu index
```


# Using Mu to index the emails

which will run `mu index` command after every sync,
[mu](https://www.djcbsoftware.nl/code/mu/) is a program that uses Xapian to
build a full text search database for the email directory, then you can use `mu`
to search in your emails, `mu` comes with `Mu4e` which is the emacs interface
for mu.

mu package is in archlinux AUR under the name `mu` so you can install it with
the AUR helpe you have, I'm using `yay` so the command for me is:

```shell
yay -S mu
```

Doing that will make offlimeimap sync the emails every 5 minutes and then
invokes `mu index` to rebuild the database.

You can use `mu` to ask for new emails now, for example I have a script that
will display the number of unread emails in my `INBOX` directories

```shell
mu find 'flag:unread AND (maildir:/account1/INBOX OR maildir:/account2/INBOX)' 2> /dev/null | wc -l
```

This will query for unread emails in the INBOX directories in each account and
then count the number of lines in the output.

I have this line in my polybar configuration which is unobtrusive way to know if
I have any new emails, instead of the annoying notifications.

# Setting up Emacs Mu4e

Now we'll need to have our Mu4e interface setup in Emacs so we can read new
emails.

I'm using spacemacs but the configuration for Gnu emacs shouldn't be different.
First we load the Mu4e package/layer.

For spacemacs users you should add the layer in your `~/spacemacs` layers list
```elisp
(mu4e :variables
     mu4e-use-maildirs-extension t
     mu4e-enable-async-operations t
     mu4e-enable-notifications t)
```

And then I load a file called `mu4e-config.el`, in the `;;;additional files`
section I require it

```elisp
(require 'mu4e-config)
```

The file lives in `~/dotfiles/emacs/mu4e-config.el` and I push this directory
path to the load-path of emacs with
```elisp
(push "~/dotfiles/emacs/" load-path)
```

The file will hold all of our Mu4e configuration

```elisp
(provide 'mu4e-config)

(require 'mu4e-contrib)

(spacemacs/set-leader-keys "M" 'mu4e)

(setq mu4e-inboxes-query "maildir:/account1/INBOX OR maildir:/account2/INBOX")
(setq smtpmail-queue-dir "~/mail/queue/cur")
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-html2text-command 'mu4e-shr2text)
(setq shr-color-visible-luminance-min 60)
(setq shr-color-visible-distance-min 5)
(setq shr-use-colors nil)
(setq mu4e-view-show-images t)
(setq mu4e-enable-mode-line t)
(setq mu4e-update-interval 300)
(setq mu4e-sent-messages-behavior 'delete)
(setq mu4e-index-cleanup nil)
(setq mu4e-index-lazy-check t)
(setq mu4e-view-show-addresses t)
(setq mu4e-headers-include-related nil)

(advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))

(with-eval-after-load 'mu4e
  (mu4e-alert-enable-mode-line-display)
  (add-to-list 'mu4e-bookmarks
               '(:name  "All inboxes"
                 :query mu4e-inboxes-query
                 :key   ?i))

  (setq mu4e-contexts
        `( ,(make-mu4e-context
             :name "account1"
             :match-func (lambda (msg) (when msg (string-prefix-p "/account1" (mu4e-message-field msg :maildir))))
             :vars '(
                     (mu4e-sent-folder . "/account1/[Gmail].Sent Mail")
                     (mu4e-drafts-folder . "/account1/[Gmail].Drafts")
                     (mu4e-trash-folder . "/account1/[Gmail].Trash")
                     (mu4e-refile-folder . "/account1/[Gmail].All Mail")
                     (user-mail-address . "account1@gmail.com")
                     (user-full-name . "Emad Elsaid")
                     (mu4e-compose-signature . (concat "Emad Elsaid\nSoftware Engineer\n"))
                     (smtpmail-smtp-user . "account1")
                     (smtpmail-local-domain . "gmail.com")
                     (smtpmail-default-smtp-server . "smtp.gmail.com")
                     (smtpmail-smtp-server . "smtp.gmail.com")
                     (smtpmail-smtp-service . 587)
                     ))
           ,(make-mu4e-context
             :name "account2"
             :match-func (lambda (msg) (when msg (string-prefix-p "/account2" (mu4e-message-field msg :maildir))))
             :vars '(
                     (mu4e-sent-folder . "/account2/[Gmail].Sent Mail")
                     (mu4e-drafts-folder . "/account2/[Gmail].Drafts")
                     (mu4e-trash-folder . "/account2/[Gmail].Trash")
                     (mu4e-refile-folder . "/account2/[Gmail].All Mail")
                     (user-mail-address . "account2@gmail.com")
                     (user-full-name . "Emad Elsaid")
                     (mu4e-compose-signature . (concat "Emad Elsaid\nSoftware Engineer\n"))
                     (smtpmail-smtp-user . "account2")
                     (smtpmail-local-domain . "gmail.com")
                     (smtpmail-default-smtp-server . "smtp.gmail.com")
                     (smtpmail-smtp-server . "smtp.gmail.com")
                     (smtpmail-smtp-service . 587)
                     ))
           )))
```

The previous configuration will define 2 different context each for every email
account, each context we tell mu4e the directories for sent, draft, trash and
archive directories.

We also told mu4e which smtp servers to use for each context. without it we'll
be able to read the emails but not send any emails. You may have noticed that
this configuration doesn't have the password for the SMTP servers.

Emacs uses a file called `~/.authinfo` to connect to remote servers, the SMTP
servers are not different for emacs, when `mu4e` tries to connect to the SMTP
server over port 587, emacs will use the credentials in this file to connect to
it.

The file content should look like this:

```
machine smtp.gmail.com port 587 login account1 password <password1>
machine smtp.gmail.com port 587 login account2 password <password2>
```

We also defined a new bookmark that shows us the inbox emails across all
accounts, it's bound to `bi`.

And we changed bound the Mu4e interface to `SPC M` where `SPC` is my leader key
in spacemacs configuration.

# How to use this setup

So now this is my workflow:

- offlineimap works in the background syncing my email to `~/mail`
- When I see the unread email count in my status bar I switch to emacs
- I press `SPC M` to open Mu4e
- I press `bi` to open the all inbox emails bookmark
- I open the email with `RET` and archive it with `r`
- When I go through all my unread emails list I press `x` to archive all emails
- I press `q` couple times to continue what I was doing in emacs


Searching through emails:

- I open Mu4e with `SPC M`
- press `s` to search, I write a word I remember about this email then `RET`
- I go through the emails with `C-j` and `C-k`
- When I'm done reading the email I was searching for I quit the email interface
  with `q`

Sending email:

- I open Mu4e with `SPC M`
- Start a new compose buffer `C`
- Fill in the `to` and `subject` fields and the message body
- Press `, c` to send it or `, k` to discard it.

# Bonus step to sync across machines

Syncing across machines works when imap sync one machine to the remove IMAP
server and the other machine do the same, if you want to make it a bit faster
you can use syncthing to sync the `~/mail` directory to your other machines, for
me I back it up to my phone and other 2 machines at the same time.
