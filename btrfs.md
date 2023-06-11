+ `gnome-disks` can create a btrfs filesystem and encrypt it with LUKS
+ `btrfs-assistant` can list subvolumes and browse their content, takes snapshots
+ to create a subvolume mount the device then `btrfs subvolume create /run/media/user/disk/subvolname`
+ to set it as default `sudo btrfs subvolume set-default /run/media/user/disk/subvolname`, remount the device

# Problems
+ Nautilus can mount and unmount
+ After creating a subvolume and set it to default, it mount but show `error finding object for block device 0:47` when unmounting. `gnome-disks` was able to unmount the device