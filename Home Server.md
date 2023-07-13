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
+ 8 TB HDD Seagate Barracuda compute

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

+ 4 disks
  + 1x8TB old disk
  + 2x8TB new disks
  + 1x1TB SSD: boot disk
+ Direct Attached Storage (DAS) box with at least 5 bays (4 for disks and 1 for replacement for disaster recovery)
+ Use the Lenovo laptop as a CPU for the DAS
+ Zigbee Dongle to control Zigbee devices (Philips Hue lights)

# Benefits of the system form
+ Replacing the laptop with a more powerful system at any time without losing the data or installing the system
+ avoided booting from the ZFS pool by adding the SSD
+ Can connect to the network over wifi or ethernet cable

# Offsite backup

#to_be_decided
+ Max total storage 15TB

# Power consumption

#to_be_decided

# Noise level

#to_be_decided
 
# Software
+ Basics
  + SSH
  + Docker compose
  + python
  + rsync

# References 
+ [Level1Linux video about LVM and LUKS](https://www.youtube.com/watch?v=kML6JWnLgHk)
+ [Level1 forum for setting up Archlinux with LVM, LUKS, RAID](https://forum.level1techs.com/t/gkh-threadripper-3970x-setup-notes/156330)
+ [Archlinux Root on ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Arch%20Linux/Root%20on%20ZFS.html)
+ [ZFS storage calculator](https://wintelguy.com/zfs-calc.pl)
+ [ZFS on /home](https://theorangeone.net/posts/zfs-on-home/)
+ [Disk prices](https://diskprices.com/)
