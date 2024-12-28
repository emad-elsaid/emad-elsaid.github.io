while checking `journalctl -ef` logs I noticed the MiraBox capture card is endlessly connecting and disconnecting.

The logs show the following on repeat every two seconds 

```shell
Dec 28 22:00:51 earth pipewire[45994]: spa.v4l2: '/dev/video0' VIDIOC_QUERYCTRL: Input/output error
Dec 28 22:00:51 earth pipewire[45994]: spa.v4l2: '/dev/video0' VIDIOC_QUERYCTRL: Input/output error
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: USB disconnect, device number 79
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: new high-speed USB device number 80 using xhci_hcd
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: New USB device found, idVendor=1e4e, idProduct=7103, bcdDevice= 1.00
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: New USB device strings: Mfr=6, Product=7, SerialNumber=3
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: Product: MiraBox Video Capture 
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: Manufacturer: MiraBox Video Capture 
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: SerialNumber: 20000130041415
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: Found UVC 1.00 device MiraBox Video Capture  (1e4e:7103)
Dec 28 22:00:54 earth kernel: usb 1-7.1.3.4: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
```


I suspected that it's put on sleep and it tries to connect again endlessly. 

And sure enough, looking in `sudo powertop` under "Tunablese" tab. the Mirabox item shows "Good" in front of it. 

The solution is to turn off the power saving from powertop. the logs stopped immediatly 
