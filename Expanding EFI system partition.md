recently I noticed that trying to `reinstall-kernels` fails because there was not enough space in my `/boot` directory. This directory is mounted from the EFI System Partition (ESP) created by windows.

Windows creats a really small partition I believe 100MB which is not enough enymore. the recommended size is 2GB. So I had to resize the partition. 

# Disks layout
I have 3 disks in my system 
- Disk1: windows
- Disk2: linux
- Disk3: windows backup partition. ESP. the rest is empty.

I don't know how I ended up with ESP on the third disk but anyways. 

So I needed to resize D3 P2 to be 2GB. turns out `gnome-disks` doesn't allow resizing the partition. and in general there is no software on linux or windows that allows manipulating this partition. 

I had to do the following: 
- Copy all `/boot` content to `/boot-backup`
- Delete the partition
- Create new partition of EF00 type, 2GB. make Fat32 filesystem on it.
- Copy back the files from `/boot-backup`
- Change the UUID of the partition to the new one in `/etc/fstab`

Rebooted and windows started automatically. the partition wasn't recognized by the motherboard. 

I tried several steps. mainly: 
- boot from archlinux USB stick
- mount the filesystem and chroot to it then mount the boot with `mount -a`
- tried to mark the ESP as boot partition. didn't work
- tried installing the EFI option with `efibootmgr` didn't work
- tried `bootctl install` that one finally worked
