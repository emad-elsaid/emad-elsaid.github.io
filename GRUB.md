I needed to reinstall GRUB on my PC after updating Archlinux as instructed here https://archlinux.org/news/grub-bootloader-upgrade-and-configuration-incompatibilities/

For me that was:
```
sudo grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
