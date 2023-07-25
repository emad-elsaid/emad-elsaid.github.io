This document describes the reasoning for building a home server machine. It is sometimes called "Home Lab". However, I won't use this term as it has been loaded with more concepts and expanded in scope. so I'll refer to what I want as a "Home Server". a machine that works 24/7 and support some use cases.

# Use Cases
This machine should support the following use cases
+ Holds backups for my VPS server. now backups are at 127GB for "Who is popular today" database over the past 11 days.
  + Auto backup VPS every day
+ Holds family documents and photos. (~57GB)
  + Phones should be able to push new photos to it
  + Family machines should be able to browse and download files and photos
+ Support VPS in administrative tasks
  + Works as a logging server
  + Monitoring and alerting
  + Control Hue lights
 
# Not a use case
+ Streaming media
+ Working with Kubernetes
+ Gaming
 
# Constraints
+ Silent
+ Lowest power usage possible
+ Lowest temperature possible
+ Smallest size possible
+ Priority is to reuse parts I have

# Guidelines
+ Learn something new
+ Minimal. no bloat

# Security
+ Data at rest encryption

# Storage reliability 
+ 1 Disk failure
  + Data redundancy to cover for 1 disk failure
  + RAID 5 (tolerates 1 device failure) or 6 (tolerates 2 devices failure) will cover this case
    + LVM has built-in raid
      + [Recovery process](https://serverfault.com/questions/959930/how-to-recover-from-drive-failure-on-lvm-software-raid-10-in-linux)
      + [LVM RAID command documentation](https://manpages.ubuntu.com/manpages/lunar/en/man7/lvmraid.7.html) - includes recovery process
    + ZFS also can do both LVM and RAID and LUKS job + it's a filesystem. doesn't need a filesystem over it like LVM does
      + It's a bit technical to get it to work with Linux
+ Whole system failure
  + Off-site backup to cover for whole system failure

# Unused hardware
I have some hardware at home that can potentially be used
+ Lenovo ThinkPad X1 Carbon laptop 9th Gen
+ Samsung 640GB USB hard desk
  + Shows signs of age. some bad sectors are reported in its SMART report
+ PC case of:
  + 8 TB HDD Seagate Barracuda compute
  + 1 TB NVME
  + 32 GB RAM
  + Nvidia RTX 2060
  + Ryzen5 3600 3.6GHz 6 cores
  + NZXT H510i case
  + Mobo: ASRock B550M pro4 micro ATX

# Consequences
+ Reduce the VPS server instance, reducing the cost per month. offloading this cost to the hardware cost, maintenance, and power consumption.
+ Alerting/Monitoring which doesn't exist right now for my side projects
+ Should help me try some software like Grafana, Loki

# VPS potential cost saving

+ Current machine [Hetzner CPX51](https://www.hetzner.com/cloud)
  + 16 AMD CPU
  + 32 GB RAM
  + 360 GB DISK
  + 20 TB traffic
  + 65 EUR/Month = 780 EUR/Year
+ Current Disk usage: 278 GB - 127 GB Backups = 151 GB
+ Memory usage is around 16GB
+ CPU util is at 35%
+ Memory and CPU can be downgraded to 16GB and 8 CPU
+ CPX41 from Hetzner satisfies Memory and CPU and has 240 GB storage with 29.39 EUR/month, 352.68 EUR/Year
+ cost saving per month = 65-29.39 = 35.61
+ cost saving per year = 35.61 * 12 = 427.32 EUR

# Minimum Specifications
Half of the VPS and all the data we have now is the minimum

+ 3 disks for RAIDZ1 (ZFS), or RAID5
+ Total disk capacity: 184 GB (exactly the current data size)
+ CPU: 8 CPU at 2.4 GHz (half of current VPS CPU)
+ Memory: 16GB

# Reasonable Specifications
More reasonable hardware based on the minimum in the previous section and taking into account the future need

+ 3 disks are fine. 4 disks to implement RAIDZ2/RAID6 can allow more resiliency
+ Total capacity should be over the combined storage of personal systems: 5 TB
+ CPU and Memory are fine at minimum

# Hardware

## Solution 1
+ 4 disks
  + 1x8TB old disk
  + 2x8TB new disks
  + 1x1TB SSD: boot disk
+ Direct Attached Storage (DAS) box with at least 5 bays (4 for disks and 1 for replacement for disaster recovery)
+ Use the Lenovo laptop as a CPU for the DAS
+ Zigbee Dongle to control Zigbee devices (Philips Hue lights)

### Benefits
+ Replacing the laptop with a more powerful system at any time without losing the data or installing the system
+ avoided booting from the ZFS pool by adding the SSD
+ Can connect to the network over wifi or ethernet cable

## Solution 2
+ Reuse the PC case
+ 2x8TB new disks
+ Zigbee Dongle to control Zigbee devices (Philips Hue lights)
+ Notes
  + NZXT caseH510i allows only for a maximum of 3 HDD
  + I can replace the case with a more suitable choice
    + [SAMA IM01 MicroATX Mini Tower Case](https://pcpartpicker.com/product/pfvdnQ/sama-im01-microatx-mini-tower-case-im01)
      + Haven't found a build that put HDDs in this case. so I'm gonna discard it
    + [Silverstone CS351 MicroATX Desktop Case](https://pcpartpicker.com/product/VcD7YJ/silverstone-cs351-microatx-desktop-case-sst-cs351)
      + 5 hot-swappable HDD

### Issues
+ will need a monitor/keyboard/mouse to unlock the encrypted disk on boot
  + [a post on level1tech](https://forum.level1techs.com/t/whats-the-common-setup-for-zfs-encrypted-home-server/199390/6) led me to the method of adding ssh to initramfs and boot from ssh
  + [PiKVM](https://pikvm.org/) can also allow for remote booting
  + [ZFSbootmenu](https://docs.zfsbootmenu.org/en/v2.2.x/)

### Benefits
+ Each component is replaceable
+ PCIe slot and 2 NVME M.2 slots on board

# Hardware Options
+ Disks
+ DAS
  + SABRENT https://www.amazon.de/dp/B07Y4F5SCK
  + ORICO
    + 5 bay https://amzn.eu/d/bmBbdtK
      + it has two variants USB 3.0 and USB 3.1 USB-C
    + https://www.amazon.de/-/en/dp/B07W6MF1TG/
  + we'll need a 3.5" to 2.5" converter for the SSD 
+ Zigbee gateway
  + ConBee II The Universal Zigbee USB Gateway https://www.amazon.de/-/en/ConBee-Universal-Zigbee-USB-Gateway-black/dp/B07PZ7ZHG5

# Hardware bought 

+ 2 Baracuda computer 8TB x 131.89EUR [(Amazon)](https://amzn.eu/d/g9KHiV9)
+ ConBee II The Universal Zigbee USB Gateway 39.95EUR [(Amazon)](https://amzn.eu/d/dNhDHIi)
+ 3 SATA cables 5.79EUR [(Amazon)](https://amzn.eu/d/aAMRBdK)

+ Total: 309.52 EUR
+ Budget remains from cost saving: 427.32 - 309.52 = 117.8 EUR

# Offsite backup

#to_be_decided
+ Max total storage 15TB

# Power consumption

#to_be_decided

# Noise level

* I found the setup is noisy a bit at night
  * 2xNoctua NF-A12x25 to replace the NZXT fans = 32.90EUR


# System 

+ Boot into ArchIso and load ZFS
  + Booting error: "failed to parse event in TPM final events log"
    + Disable TPM from UEFI setup: Security Device Support
    + Rewrote the ISO to the USB stick
      
+ Black screen after booting
  + Nvidia issue: added `nomodeset` to kernel options
    
+ `curl -s https://raw.githubusercontent.com/eoli3n/archiso-zfs/master/init | bash`
  + no networking `networkctl` shows `configuring`
  + removed the cable from the USB dock and connected it directly to the machine

+ `zpool create -o ashift=12 -o autotrim=on -R /mnt -O acltype=posixacl -O relatime=one -O xattr=sa -O canmount=off -O compression=lz4 -O dnodesize=legacy -O normalization=formD -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt -O dedup=on zroot raidz1 /dev/disk/by-id/ata-<id>`
  + compressed, encrypted, deduplication, raidz1
  + archlinux AUR script is marked as out of date, can't find kernel version

+ `mkinitcpio` fails as `libcrypto` doesn't exist https://github.com/archzfs/archzfs/issues/464
  + install `openssl-1.1` package

+ after reboot with zfsbootmenu it loads the kernel and asks for the password then stops
  +  loaded the live USB again and changed `zfs set canmount=on zroot/ROOT/default`
  +  Generate fstab `/etc/fstab`
  +  set `zfs set org.zfsbootmenu:commandline="nomodeset rw loglevel=4" zroot/ROOT/default`

+ :confetti_ball: Finally booted to the new system and logged in to my user

+  Network is not working
  +  configure systemd-networkd
+  DNS is not working
  +  enable systemd-resolved
    
+  installed Openssh, allow my user and copy ssh key then disable password login
+  installed docker, docker-compose, rsync, python3


# Booting using SSH
* Clone zfsbootmenu
* Run `./contrib/remote-ssh-build.sh`
* `sudo cp build/vmlinuz.EFI <disk>/EFI/BOOT/BOOTX64.EFI`
* `dracut-network.conf` should include something like `ip=<IP>::<gateway>:255.255.255.0:homeserver:[<mac>]:none rd.neednet=1`

* ssh permission denied
  * `authorized_keys` had wrong owner `chown root:root dropbear/authorized_keys`

* setup system initramfs to include the passphrase to stop second passphrase prompt


# Software
+ Basics
  + SSH
  + Docker compose
  + python
  + rsync
  + powertop
  + lm-sensors

# Containers
* [Photoprism](https://www.photoprism.app/): alternative to google photos
* [Syncthing](https://syncthing.net/): alternative to dropbox, google drive...etc

# References 
+ [Level1Linux video about LVM and LUKS](https://www.youtube.com/watch?v=kML6JWnLgHk)
+ [Level1 forum for setting up Archlinux with LVM, LUKS, RAID](https://forum.level1techs.com/t/gkh-threadripper-3970x-setup-notes/156330)
+ [Archlinux Root on ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Arch%20Linux/Root%20on%20ZFS.html)
+ [ZFS storage calculator](https://wintelguy.com/zfs-calc.pl)
+ [ZFS on /home](https://theorangeone.net/posts/zfs-on-home/)
+ [Disk prices](https://diskprices.com/)
+ Sourcing hardware
  + [Alternate.de](https://www.alternate.de/)
  + [Ali Express](https://de.aliexpress.com/)
  + [Kleinanzeigen](https://www.kleinanzeigen.de/stadt/berlin/)
+ Installing ArchZFS
  + https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
  + https://github.com/eoli3n/archiso-zfs
  + https://openzfs.github.io/openzfs-docs/Getting%20Started/Arch%20Linux/Root%20on%20ZFS.html
