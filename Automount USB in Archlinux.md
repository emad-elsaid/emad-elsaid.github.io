* Create a script that watches new devices and mount them. I'll call it `automount` ([ref](https://wiki.archlinux.org/title/Udisks#:~:text=as%20root.-,udevadm%20monitor,-You%20may%20use))

```shell
#!/usr/bin/env bash

pathtoname() {
    udevadm info -p /sys/"$1" | awk -v FS== '/DEVNAME/ {print $2}'
}

stdbuf -oL -- udevadm monitor --udev -s block | while read -r -- _ _ event devpath _; do
        if [ "$event" = add ]; then
            devname=$(pathtoname "$devpath")
            udisksctl mount --block-device "$devname" --no-user-interaction || true
        fi
done
```

* Give it execute permission `chmod +x automount`
* The path on my machine to this script is `/home/emad/dotfiles/bin/automount`
* Create a systemd service in `~/.config/systemd/user/automount.service` to run the script for the user
```systemd
[Unit]
Description=Automount usb devices when plugged

[Service]
Type=simple
ExecStart=%h/dotfiles/bin/automount

[Install]
WantedBy=default.target
```
* Then enable the service for current user `systemctl --user enable --now automount`
* Everytime a device is plugged in. its partitions will be mounted to `/run/media/$USER/{patition-label}`