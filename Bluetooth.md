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


# On 2023/Jul/01 bluetooth was crashing after connecting

+ a Bug is blueman package that require downgrading: https://bbs.archlinux.org/viewtopic.php?pid=2107396#p2107396

# On 2025/Apr/06 Speaker audio stutter for both speaker and headphone

Every minute or so, the audio stutter and stops for a couple of seconds. 
`btmgmt` command shows the following everytime this happens: 
```
hci0 xx:xx:xx:xx:xx:xx type BR/EDR connect failed (status 0x04, Connect Failed)
```

I noticed this `xx:xx:xx:xx:xx:xx` is the id of the bluetooth speaker. it happened while I'm using the headphones. so this means the stutter is because the machine tries to connect to the other speaker (even when the speaker was off). 

So I disabled the "auto reconnect" for both devices to avoid this issue. and it fixed the issue for me.
