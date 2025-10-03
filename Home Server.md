![](/public/4cde64caa0279c1d3343d36cd755a2aa1539faebcc68cb18f62e057f075a9b61.jpg)

#hardware #server #sideproject #ZFS #archlinux #youtube_video

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
  + Ryzen5 3600 3.6GHz 6 cores (6 core x 2 threads)
  + NZXT H510i case
  + Mobo: [ASRock B550M pro4 micro ATX](https://www.asrock.com/mb/AMD/B550M%20Pro4/index.asp#Specification)

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
+ M.2 Wifi slot on board

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

+ **Boot into ArchIso and load ZFS**
  + Booting error: "failed to parse event in TPM final events log"
    + Disable TPM from UEFI setup: Security Device Support
      
+ **Black screen after booting**
  + Nvidia issue: added `nomodeset` to kernel options
    
+ **`curl -s https://raw.githubusercontent.com/eoli3n/archiso-zfs/master/init | bash`**
  + no networking `networkctl` shows `configuring`
  + removed the cable from the USB dock and connected it directly to the machine

+ **Create ZFS pool**
  + `zpool create -o ashift=12 -o autotrim=on -R /mnt -O acltype=posixacl -O relatime=one -O xattr=sa -O canmount=off -O compression=lz4 -O dnodesize=legacy -O normalization=formD -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt -O dedup=on zroot raidz1 /dev/disk/by-id/ata-<id>`
  + compressed, encrypted, deduplication, raidz1
  + Archlinux AUR script is marked as out of date, can't find kernel version

+ **`mkinitcpio` fails as `libcrypto` doesn't exist https://github.com/archzfs/archzfs/issues/464**
  + install `openssl-1.1` package

+ **after reboot with zfsbootmenu it loads the kernel and asks for the password then stops**
  +  loaded the live USB again and changed `zfs set canmount=on zroot/ROOT/default`
  +  Generate fstab `/etc/fstab`
  +  set `zfs set org.zfsbootmenu:commandline="nomodeset rw loglevel=4" zroot/ROOT/default`

+ :confetti_ball: Finally booted to the new system and logged in to my user

+ **Network is not working**
  +  configure systemd-networkd for static IP
+ **DNS is not working**
  + enable systemd-resolved
+  installed Openssh, allow my user and copy SSH key then disabled password login
+  installed docker, docker-compose, rsync, python3


# Booting using SSH
* Clone zfsbootmenu
* Run `./contrib/remote-ssh-build.sh`
* `sudo cp build/vmlinuz.EFI <disk>/EFI/BOOT/BOOTX64.EFI`
* `dracut-network.conf` should include something like `ip=<IP>::<gateway>:255.255.255.0:homeserver:[<mac>]:none rd.neednet=1`

* **ssh permission denied**
  * `authorized_keys` had wrong owner `chown root:root dropbear/authorized_keys`

* **system asks for password again**
  * Setup system initramfs to include the passphrase file to stop second passphrase prompt


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
* [Traefik](https://traefik.io/): as HTTP router
* [Home Assistant](https://www.home-assistant.io/): control light 

# Benchmarking

Using [Unix Benchmark](https://wiki.archlinux.org/title/benchmarking#Standalone_tools)
```
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: : GNU/Linux
   OS: GNU/Linux -- 5.18.6-arch1-1 -- #1 SMP PREEMPT_DYNAMIC Wed, 22 Jun 2022 18:10:56 +0000
   Machine: x86_64 (unknown)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   CPU 0: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 1: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 2: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 3: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 4: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 5: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 6: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 7: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 8: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 9: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 10: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   CPU 11: AMD Ryzen 5 3600 6-Core Processor (7189.9 bogomips)
          Hyper-Threading, x86-64, MMX, AMD MMX, Physical Address Ext, SYSENTER/SYSEXIT, AMD virtualization, SYSCALL/SYSRET
   17:12:05 up 32 min,  1 user,  load average: 0.33, 0.20, 0.18; runlevel

------------------------------------------------------------------------
Benchmark Run: Wed Jul 26 2023 17:12:05 - 17:41:50
12 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables       52901528.7 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     9173.2 MWIPS (10.0 s, 7 samples)
Execl Throughput                               7207.1 lps   (29.3 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        315773.4 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           80529.9 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1171845.0 KBps  (30.0 s, 2 samples)
Pipe Throughput                             2703933.8 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 316754.7 lps   (10.0 s, 7 samples)
Process Creation                              10246.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   6614.6 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   3543.6 lpm   (60.0 s, 2 samples)
System Call Overhead                        3146084.4 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   52901528.7   4533.1
Double-Precision Whetstone                       55.0       9173.2   1667.8
Execl Throughput                                 43.0       7207.1   1676.1
File Copy 1024 bufsize 2000 maxblocks          3960.0     315773.4    797.4
File Copy 256 bufsize 500 maxblocks            1655.0      80529.9    486.6
File Copy 4096 bufsize 8000 maxblocks          5800.0    1171845.0   2020.4
Pipe Throughput                               12440.0    2703933.8   2173.6
Pipe-based Context Switching                   4000.0     316754.7    791.9
Process Creation                                126.0      10246.4    813.2
Shell Scripts (1 concurrent)                     42.4       6614.6   1560.0
Shell Scripts (8 concurrent)                      6.0       3543.6   5906.1
System Call Overhead                          15000.0    3146084.4   2097.4
                                                                   ========
System Benchmarks Index Score                                        1593.8

------------------------------------------------------------------------
Benchmark Run: Wed Jul 26 2023 17:41:50 - 18:13:01
12 CPUs in system; running 12 parallel copies of tests

Dhrystone 2 using register variables      452528054.3 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                    95126.5 MWIPS (10.0 s, 7 samples)
Execl Throughput                              36518.9 lps   (29.7 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        687753.1 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          175226.1 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       2643789.0 KBps  (30.0 s, 2 samples)
Pipe Throughput                            22267414.7 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                2332771.7 lps   (10.0 s, 7 samples)
Process Creation                              88665.5 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                  44352.6 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   5034.3 lpm   (64.5 s, 2 samples)
System Call Overhead                       13947317.3 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0  452528054.3  38777.0
Double-Precision Whetstone                       55.0      95126.5  17295.7
Execl Throughput                                 43.0      36518.9   8492.8
File Copy 1024 bufsize 2000 maxblocks          3960.0     687753.1   1736.8
File Copy 256 bufsize 500 maxblocks            1655.0     175226.1   1058.8
File Copy 4096 bufsize 8000 maxblocks          5800.0    2643789.0   4558.3
Pipe Throughput                               12440.0   22267414.7  17899.9
Pipe-based Context Switching                   4000.0    2332771.7   5831.9
Process Creation                                126.0      88665.5   7036.9
Shell Scripts (1 concurrent)                     42.4      44352.6  10460.5
Shell Scripts (8 concurrent)                      6.0       5034.3   8390.5
System Call Overhead                          15000.0   13947317.3   9298.2
                                                                   ========
System Benchmarks Index Score                                        7436.9
```

# Optimizations
+ Add a read cache disk `sudo zpool add zroot cache /dev/disk/by-id/<disk-id>`
+ Disable sync writes for faster writes `sudo zfs set sync=disabled zroot`

# After upgrading CPU
+ Nvidia graphics didn't work with archlinux+zfs so I had to remove it instead of risking an upgrade of the kernel that may break ZFS module
+ The CPU doesn't have integrated graphics to I upgraded to Ryzen5 5600G
+ The motherboard needed a firmware update to support it
+ I made a mistake and didn't install the fan on the CPU to save time
+ The CPU overheated during the firmware upgrade and the motherboard didn't start anymore'
+ I had to replace the motherboard with another of the same model
+ The motherboard worked
+ starting up fails with dracut because it didn't find the same network mac address!!!
+ I had to compile the EFI image again of zbm and start again
+ the network on the new system is not enabled so I had to enable and add static IP
+ I had the config in `/etc/systemd/network/20-wired.network` and the interface was `enp6s0` the new motherboard device name is `enp3s0` why is it different? I have no idea 


# Youtube

https://www.youtube.com/watch?v=j7VMpcGGyhU

Title
> [Arabic] 14TB Archlinux Linux ZFS Home server Build |  ارتش لينكس 14 تيرابايت سيرفر للبيت

Description

# Update 03-10-2025
* I heared continious clicking from the server at all times.
* I thought it was needle parking noise as segate is famous for this behavior. so I first turned off all new docker containers I started such as gitlab, gitlab runner, AI UI, ollama. The issue didn't go away.
* Then I tried to run ZFS scrub. it took around a day to finish and the issue went away. then appeared again.
* So I tried to clean the server.
  * Turning on the server didn't POST. just the case light and the fans are running, no noise or beeps.
  * connected a GPU and monitor, keyboard, mouse. didn't work.
  * Opened it again and pressed on every component and cable.
  * That fixed the POST issue. next the Dracut stick wasn't recognized at all, changed the USB port and it worked.
  * Booting to the system and found the network interface was down and instead of enp3s0 it was enp4s0 that's because the enumeration of MOBO of buses was different. trying `networkctl up enp4s0` failed with error that the driver can't be loaded. also I remembered the CPU as  integrated graphics.
  * Removed the GPU and rebooted, it worked as expected.

 
> شرح تفصيلي لمشروع ارتش لينكس سيرفر للبيت واختيارات الهاردوير والسوفتوير والمميزات التي تم اختيارها مثل ZFS, Zigbee gateway, Docker containers, Self hosted services
معلومات تفصيلية عن المشروع: https://www.emadelsaid.com/Home%20Server/
المشروع على جيت هب: https://github.com/emad-elsaid/home
#ZFS #archlinux #arabic #home_automation #RAID

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
