![](/public/4020dbfc96c350beaa20ce793a293abe82f81556c65fce956b4f36f331dbd761.jpg)

#archlinux

List packages installed from AUR
```shell
pacman -Qm
```

Delete any AUR (foreign) packages that includes `python2` in the name
```shell
sudo pacman -Rs `pacman -Qm | awk '/python2/{ print $1 }'`
```

Update keyring 
```shell
sudo pacman -Sy archlinux-keyring
```