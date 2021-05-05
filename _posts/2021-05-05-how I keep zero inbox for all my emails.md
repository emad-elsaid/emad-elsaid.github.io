---
title: How I keep zero inbox for all my emails
---

I have this habit for a while now. And I noticed people around me struggle keeping their Email inbox clean. Every time I see someones screen with his inbox on it seems like a pipe of emails just exploded in his inbox and he's to his knees in a mix of read and unread emails. So here is how I do it.

# Unsubscribe

When I see an email that I don't want to see again I just unsubscribe from it. all marketing emails, updates from linkedin, Facebook, twitter. I don't need to be alerted every time someone sends me a message or mentions me. So every time I see an email from a company not a person I search for the "Unsubscribe" link and click it. now this one email is gone from my life hopefully forever.

# Archive

Gmail had the archive directory forever now. since they introduced it years ago I put all emails that I read there. I don't need to see the same email twice unless I have to reply to it later. So that leaves my inbox with unread emails and emails I have to respond to it later.

# Respond

I try to respond to emails as soon as I read them. unless it require some research or an action that will take time I leave them there and get back to them when I need to. but as a rule I respond almost at the same time I see the email.

It helped me [integrating the email in my Emacs editor with Mu4e package](/using-emacs-for-as-email-client) I bind the email screen to `SPC M` then `bi` to get all emails from all inboxes of all my emails personal and work. read them and archive the ones I don't need to see again. respond and close the screen. it takes couple seconds to do that.

# Turn off intrusive notifications

I know there is an email when I see the number in my [polybar](https://github.com/polybar/polybar) changes

![Screenshot-2021-05-05_10-48-55.png](/images/Screenshot-2021-05-05_10-48-55.png)

This number shows my unread emails in all of my inboxes. I don't get notifications just this little number. and If I want to focus on something without my eye hitting the bar like when writing this blog post for example. I put the window in Full-screen mode which hides the bar.

This way I can be in the flow of coding or reading then when I'm checking the time I see there is an email and I can switch to it, read it then close the buffer.

# I don't need directories

All my emails are offline on my machine synced with [offlineimap](http://www.offlineimap.org/) so when I need to search for an email I don't open Gmail interface. just `SPC M` and `s` for search, write what I want to search for and I get everything from my disk in my editor, read through them and close the buffer when I'm done.

This means I don't need to categorize emails or any complicated filters. just read, archive, search everything when you need it. simple.
