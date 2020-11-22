---
title: Moving from Lastpass.com to KeePassXC on Linux/Android/Windows
image: /images/IMG_20200805_201728.jpg
image_alt: Berlin Spree
---

As part of my effort to reduce my dependency on SaaS service today I moved from
[lastpass.com](https://www.lastpass.com/) to [keepassxc](https://keepassxc.org/)
That means my usernames/password are no longer data stored in the cloud of
lastpass but on my machine as a keepass database file. Here is how I did the
migration.

Installed Keepassxc

```
sudo pacman -S keepassxc
```

Then I exported lastpass data as CSV from a feature hidden on the side bar "More
Options" -> "Advanced" -> "Export" or reach the page [ from here ](https://lastpass.com/export.php).

Open keepassxc and import from CSV file, you'll be presented with a dialog to
choose the file, then asked to map the columns to their correct fields in
keepassxc.

Hint: check the option that says the first row is the column names to show you
the column name instead of their numbers.

Now I have the database, saved it to a directory that's shared with syncthing
between my machines and my phone (so now I get the database over all my machines)

Delete the CSV file as we're done with it.

From keepassxc settings you need to enable couple options:

- General: Automatically launch KeePassXC at system startup
- General: Mimimuze window at application startup
- General: Minimize window after unlocking database
- General: Minimize instead of app exit
- General: Show a system tray icon (I choose the monochrome (light))
- Browser Integration: "enabled browser integration" then check your browser
  name from the list.

I'm using google chrome so I uninstalled the lastpass extension and installed
keepassxc extension, the link is over the browsers list in the settings.

When you install the extension click the icon and choose the link your local
keepassxc to it and write a name for it.

I'm using an android phone with syncthing synching many directories from and to
the phone, one of them is the directory that hold this passwords database.

So I installed [ one of the recommended android applications by the keepassxc
team
](https://play.google.com/store/apps/details?id=keepass2android.keepass2android)
then I opened the database with it and enabled the biometric authentication,
then uninstalled lastpass application.

I was surprised by how the extension looked better than lastpass extension
inside the page.

On the windows PC the process was the same, installed keepassxc, installed the
extension, opened the database with keepassxc and linked the extension to it.

So here is one less thing that I removed from the list of SaaS I depend on.
