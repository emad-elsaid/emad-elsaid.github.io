+ Install `isync` and `neomutt` : `sudo pacman -S isync neomutt`
+ Configure isync in `~/.mbsyncrc`
```conf
IMAPAccount you@gmail.com
Host imap.gmail.com
User you@gmail.com
PassCmd "command to return pass"
SSLType IMAPS

IMAPStore you@gmail.com-remote
Account you@gmail.com

MaildirStore you@gmail.com-local
SubFolders Verbatim
# The trailing "/" is important
Path  ~/Mail/you@gmail.com/
Inbox ~/Mail/you@gmail.com/Inbox

Channel you@gmail.com
Near :you@gmail.com-local:
Far  :you@gmail.com-remote:
Patterns *
Create Both
Expunge Both
SyncState *
```