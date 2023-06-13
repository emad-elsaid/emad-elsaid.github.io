+ turn on android debugging settings
+ install `scrcpy` `sudo pacman -S scrcpy`
+ connect the phone with usb cable
+ `scrcpy -k` to connect to the phone
+ in another terminal `adb shell am start -a android.settings.HARD_KEYBOARD_SETTINGS` this opens a window
+ add the keyboard layouts for the keyboard (for me english and arabic)
+ I have to execute `adb shell am start -a android.settings.HARD_KEYBOARD_SETTINGS` to change keyboard `shift+space` doesn't work (it shows the message that the layout changed but it doesn't actually change while typing)
