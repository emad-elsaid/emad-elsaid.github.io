---
title: "Window10 Disconnects Reconnects Usb Bluetooth"
date: 2020-05-15T11:19:51+02:00
---

On my PC I have windows 10 + USB bluetooth I use them for gaming with wireless xbox controller.

I noticed in idle times that the PC was making sound of a USB device
disconnecting, this is something that shouldn't be hapenning, I wasn't using the
machine and it was idle doing nothing.

## Debugging

I wanted to see some system logs like `journalctl` we have on linux, the nearest
logger I found was the windows events viewer, under "System" I found warnings
and errors from "Bluetooth HID device either went out of range or became
unresponsive".

So now I know that the problem is the USB bluetooth stick not any other USB
device.

1. looking around the Device manager I found "Generic bluetooth radio" device,
1. Under properties there is a tab for "Power Management"
1. "Allow the computer to turn off this device to save power" was enabled, so I
   disabled it


That solved the issue. I have 2 other issues that I'm not sure yet if this
solved them or not:

1. Bluetooth mouse was disconnecting randomly while I was using it (not when the
   machine is in Idle state)
1. While gaming with dual screens the game was minimizing randomly

My assumption is the first problem is related to the bluetooth disconnecting
(even while I'm not idle)

The second issue Is probably the same issue, but windows wants to show an error
event that steals the focus from the fullscreen window.

I didn't validate that these issues are solved yet.
