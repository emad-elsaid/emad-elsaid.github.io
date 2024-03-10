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

I got it to work. the previous problem was solved. probably packages are updated to address the issue. the following is the complete setup 

```ruby
require 'bundler/inline'

gemfile do
  source "https://rubygems.org"

  gem "archlinux",
      # github: "emad-elsaid/archlinux"
      path: "/home/emad/code/archlinux"
end

require_relative 'display_server'

# Config
def nvidia
  package "nvidia-dkms"

  file '/etc/modprobe.d/nvidia.conf', <<~CONTENT
    options nvidia-drm modeset=1
  CONTENT
end

def spacemacs
  github_clone from: "syl20bnr/spacemacs", to: "~/.emacs.d"

  on_install do
    system "gem install --conservative --no-post-install-message solargraph pry rubocop prettier seeing_is_believing"
  end
end

linux do
  hostname 'earth'

  timedate timezone: 'Europe/Berlin',
           ntp: true

  locale "en_US.UTF-8"
  keyboard keymap: 'us',
           layout: "us,ara",
           model: "",
           variant: "",
           options: "ctrl:nocaps,caps:lctrl,ctrl:swap_lalt_lctl,grp:alt_space_toggle"

  # Core ==========
  package %w[
          linux
          linux-firmware
          linux-headers
          base
          base-devel
          bash-completion
          pacman-contrib
          xdg-user-dirs
          man-db
          ]

  # Networking =====
  package %w[
          dhcpcd
          dhcp
          network-manager-applet
          networkmanager
          networkmanager-openvpn
          nm-connection-editor
          traceroute
          avahi
          iftop
          nmap
          ]

  # Hardware ========
  package %w[
          acpi
          blueman
          bluez
          bluez-utils
          fwupd
          guvcview
          pavucontrol
          usbutils
          v4l2loopback-dkms
          exfat-utils
          system-config-printer
          xf86-video-intel
          brightnessctl
          sof-firmware
          ]

  # CPU
  package 'intel-ucode'

  # Display =======
  wayland
  nvidia
  # xorg

  # Services =====
  package %w[
          mate-notification-daemon
          syncthing
          dbus-broker-units
          ]

  # CLIs =========
  package %w[
          sudo
          time
          less
          bat
          cloc
          calc
          ctop
          iotop
          htop
          dialog
          fzf
          grep
          gzip
          jq
          lshw
          lsof
          ncdu
          pv
          ranger
          rsync
          the_silver_searcher
          tree
          unrar
          unzip
          wget
          whois
          zip
          locate
          jpegoptim
          nano
          powertop
          imagemagick
          ]

  # Apps =========
  package %w[
          eog
          eog-plugins
          gnome-disk-utility
          gnome-keyring
          nautilus
          kitty
          gimp
          inkscape
          obs-studio
          vlc
          keepassxc
          keybase-gui
          rawtherapee
          shotwell
          ]

  # Themes ========
  package %w[
          lxappearance-gtk3
          elementary-icon-theme
          gtk-theme-elementary
          arc-gtk-theme
          capitaine-cursors
          inter-font
          noto-fonts
          noto-fonts-emoji
          powerline-fonts
          ttf-dejavu
          ttf-font-awesome
          ttf-jetbrains-mono
          ttf-liberation
          ttf-ubuntu-font-family
          ]

  # Dev tools =====
  package %w[
          android-tools
          make
          autoconf
          automake
          clang
          dbeaver
          jdk-openjdk
          emacs-wayland
          neovim
          docker
          docker-compose
          github-cli
          graphviz
          git
          ]

  # Prog. langs ===
  package %w[ruby go python npm]

  # Utils =========
  package %w[aspell-en man-pages]

  # Libs =========
  package 'postgresql-libs'

  service %w[
          avahi-daemon
          bluetooth
          docker
          NetworkManager
          ]

  timer 'plocate-updatedb'

  ufw :syncthing

  replace '/etc/mkinitcpio.conf', /^(.*)base udev(.*)$/, '\1systemd\2'

  # Set 2 TTY instead of the default 6
  replace '/etc/systemd/logind.conf', /^.*NAutoVTs=.*$/, 'NAutoVTs=2'

  # Make sure /boot is not world accessible https://bbs.archlinux.org/viewtopic.php?id=287790
  replace '/etc/fstab', /^(.*\/boot.*)fmask=\d*,(.*)$/, '\1fmask=0077,\2'
  replace '/etc/fstab', /^(.*\/boot.*)dmask=\d*,(.*)$/, '\1dmask=0077,\2'

  # remove bootloader timeout
  replace '/boot/loader/loader.conf', /^#?timeout.*$/, 'timeout 0'

  # Download in parallel
  replace '/etc/pacman.conf', /^.*ParallelDownloads.*$/, 'ParallelDownloads = 5'

  # Don't clear boot messages
  file '/etc/systemd/system/getty@tty1.service.d/noclear.conf', <<~FILE
    [Service]
    TTYVTDisallocate=no
  FILE

  on_finalize do
    sudo 'bootctl install'
    sudo 'reinstall-kernels'
  end

  user 'emad', groups: ['wheel', 'docker'], autologin: true do
    on_install do
      system "go install github.com/cespare/reflex@latest"
      system "xdg-user-dirs-update"
    end

    aur %w[
        kernel-install-mkinitcpio
        xlog-git
        units
        google-chrome
        ttf-amiri
        ttf-mac-fonts
        ttf-sil-lateef
        ttf-arabeyes-fonts
        ttf-meslo
        aspell-ar
        autoenv-git
        siji-git
        zoom
        ]

    service %w[
            ssh-agent
            syncthing
            keybase
            kbfs
            automount
            ]

    timer 'checkupdates'

    mkdir %w[
          ~/Pictures/screenshots
          ~/code
          ~/.config
          ]

    files = Dir.glob("./user/**/*", File::FNM_DOTMATCH)
    files.select! { |f| File.file?(f) }

    files.each do |src|
      dest = "~"  + src.delete_prefix("./user")
      symlink src, dest
    end

    spacemacs
  end
end
```

The previous script uses [Archlinux Gem](https://github.com/emad-elsaid/archlinux) I'm developing. you can translate it to steps you do manually. 

