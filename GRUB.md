I needed to reinstall GRUB on my PC after updating Archlinux as instructed here https://archlinux.org/news/grub-bootloader-upgrade-and-configuration-incompatibilities/

For me that was:
```bash
sudo grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

# Installing themes

for example https://github.com/AllJavi/tartarus-grub/tree/master 
```bash
sudo cp tartarus -r /usr/share/grub/themes/
sudo vim /etc/default/grub
# change GRUB_THEME= to GRUB_THEME="/usr/share/grub/themes/tartarus/theme.txt"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```