#linux #bluetooth #windows #snippet 

* I use Bluetooth speakers for my PC. 
* Also this PC has windows 10 and Linux dualboot
* So connecting the speaker to one system and switching will make the pairing in the other system invalid
* Pairing windows can be reset by removing the device from the list of bluetooth devices and pairing it again
* linux on the other hand (using blueman-devices) fails for somereason to remove the device and pair again.
* pairing from command line worked

```shell
bluetoothctl
scan on
pair <device>
trust <device>
connect <device>
```

I tried to do it from blueman devices interface and it took over half an hour and one time restarting and removing/installing the bluetooth adapter.  then tried the CLI and it worked in a minute.