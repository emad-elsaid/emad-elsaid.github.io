* After installing linux on a laptop I noticed that Arch installed created 20G for root and the rest of the disk for `/home`
* I needed to merge them into one. 20G for `/` is too small and I don't need the separation

# Solution
* Boot into archlinux usb
* `mkdir disk` and `mkdir home`
* Mount partitions to it `mount /dev/nvme0n1p2 disk` and `mount /dev/nvme0n1p3 home`
* Copy the content of home to the one inside the other partition `cp -r home/emad disk/home/`
* Remove the `/home` desk line from `disk/etc/fstab`. I commented mine just in case.
* unmount home `umount home`
* Run `cfdisk /dev/nvme0n1`. removed the `/home` partition (p3) and resize (p2) to fill the rest of the space. cfdisk will default to the rest of the space. very helpful
* Write the partition table and quit
* unmount the disk `umount disk`
* Reboot

# What I missed
* Copying the home files changed the ownership so I had to login with root and `chown -R emad:emad /home/emad`
* Running `df -h .` still shows the root size = 20G. that's because we resized the partition but the filesystem still thinks it's 20G.
  * So resize the filesystem to fill all the partition `sudo resize2fs /dev/nvme0n1p2`
* Another reboot is needed as my user session needed a clean start
