* Archlinux, Hyprland setup
* I had weird problem that comes and goes randomly
* When starting nautilus it takes too long. same if I tried to open any GTK dialog like open file, save file dialogs
* Also Flatpak applications doesn't start

All of these symptoms happen at the same time at random times. when it happens it happens for days. then it disappear (not sure of the trigger or the reason it's fixed)

* Turns out the issue was that I start Hyprland from `.bash_profile` using `exec Hyprland`.
* The solution is to start Hyrprland with dbus session `exec dbus-run-session -- Hyprland`


# Update 17-07-2025

It seems the problem persisted. I used cursor to debug the issuee and it came up with a solution. 

Add the following to `.bash_profile` 
```
export GIO_USE_VFS=local        # Use local VFS instead of GNOME's gvfs
export GTK_USE_PORTAL=0         # Disable XDG portals for GTK apps
export GDK_BACKEND=wayland      # Ensure proper Wayland backend
export QT_QPA_PLATFORM=wayland  # Ensure proper Wayland for Qt apps
```


# Update 03-11-2025

I installed `power-profiles-daemon` and when setting the battery aware setting it couldn't connect to d-bus. although it's installed. but again the logs shows: 
```
dbus-daemon[1108]: [system] Activation via systemd failed for unit ‘dbus-org.freedesktop.home1.service’: Unit dbus-org.freedesktop.home1.service not found.
```

[Thanks to this](https://forum.manjaro.org/t/dbus-org-freedesktop-home1-service-not-found-i-set-noextract-usr-lib-security-pam-systemd-home-so-in-pacman-conf/77365) thread. it seems like systemd-homed is disabled. and this is the reason for this issue. 

after homed was enabled with `sudo systemctl enable --now systemd-homed` and restarting it worked. flatpak applications started as expected. 
