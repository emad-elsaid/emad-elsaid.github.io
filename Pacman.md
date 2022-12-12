List packages installed from AUR
```shell
pacman -Qm
```

Delete any AUR (foreign) packages that includes `python2` in the name
```shell
sudo pacman -Rs `pacman -Qm | grep python2 | awk '{ print $1 }'`
```