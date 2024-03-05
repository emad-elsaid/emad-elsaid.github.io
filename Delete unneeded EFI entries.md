# Problem
* After installing linux multiple times in a UEFI machine you end up with multiple EFI entries like the following

```
➜ sudo efibootmgr -v
BootCurrent: 0006
Timeout: 0 seconds
BootOrder: 0006,001D,001A,001B,001C,001E,001F,0020,0021,0022
Boot0006* Linux Boot Manager    HD(1,GPT,e4ad3f45-13ad-4a17-97a6-8b34f22690a9,0x800,0x100000)/\EFI\systemd\systemd-bootx64.efi
      dp: 04 01 2a
```
* You'll have multiple entries for "Linux Boot Manager"

# Removing the entries
* Each entry is identified by a number `0006` in `Boot0006`
* To remove entry `0006` you can run `sudo efibootmgr -b 0006 -B`
* The line `BootCurrent` identify the entry that's used to boot the current system so delete "Liux Boot Manager" entry except for this one.

