To install wayland and associated tools I did the following

# Tools exchange
- Wayland
- Xserver + i3 -> Hyprland
- Polybar -> Waybar
- Feh -> Hyprpaper
- scrot -> grim, slurp

# Commands
```bash
sudo yay -S wayland hyprland waypaper qt5-wayland qt5ct libva nvidia-vaapi-driver-git waybar-hyprland-git pipewire wireplumber qt6-wayland xdg-desktop-portal-wlr
sudo systemctl start seatd
sudo usermod -a -G seat <user>
```

# Problems
Although it worked mostly there were problems

- screensharing didn't work with both desktop-portal implementations -wlr and -hyprland

# Update 10/March/2024

I got it to work. the previous problem was solved. probably packages are updated to address the issue. the following is the setup 

```ruby
require 'bundler/inline'

gemfile do
  source "https://rubygems.org"

  gem "archlinux",
      # github: "emad-elsaid/archlinux"
      path: "/home/emad/code/archlinux"
end

def wayland
  package %w[
          hyprland
          xorg-xwayland
          waybar
          wofi
          hyprpaper
          swaylock
          grim
          slurp
          wl-clipboard
          ]

  # This is what allowed screen recording, pulseaudio without pipewire doesn't
  # allow it
  package %w[
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
          pipewire
          pipewire-audio
          pipewire-alsa
          pipewire-pulse
          wireplumber
          pavucontrol
          libpulse
          ]
end

linux do
  wayland
end
```

The previous script uses [Archlinux Gem](https://github.com/emad-elsaid/archlinux) I'm developing. you can translate it to steps you do manually. 

