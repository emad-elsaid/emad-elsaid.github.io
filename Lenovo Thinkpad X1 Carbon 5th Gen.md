# Fingerprint reader with Arch linux

* libfprint is the project that support the finerprint readers. to know if device is supported get the device ID

```bash
$ lsusb
Bus 001 Device 005: ID 138a:0097 Validity Sensors, Inc.
```
* it's on the list of [unsupported devices](https://gitlab.freedesktop.org/libfprint/wiki/-/wikis/Unsupported%20Devices#:~:text=udev%20rule%20generator.-,138a%3A0097,-thinkpad%20t470p)
* the discussion is Lenovo website is [here](https://forums.lenovo.com/t5/_/Validity-Fingerprint-Reader-Linux/td-p/3352145) 