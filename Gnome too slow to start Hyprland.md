* Archlinux, Hyprland setup
* I had weird problem that comes and goes randomly
* When starting nautilus it takes too long. same if I tried to open any GTK dialog like open file, save file dialogs
* Also Flatpak applications doesn't start

All of these symptoms happen at the same time at random times. when it happens it happens for days. then it disappear (not sure of the trigger or the reason it's fixed)

* Turns out the issue was that I start Hyprland from `.bash_profile` using `exec Hyprland`.
* The solutions is to start Hyrprland with dbus session `exec dbus-run-session -- Hyprland`
