![](/public/8ef86af5f07f7429a4e48afea2bb6830eba5afd5ddb203e1538bd8a2fd4449a2.jpg)

I recieved my [Nreal Air](https://www.nreal.ai/air) Thursday 08 2022. Imported from US as it's not sold yet in Germany. Bought from Amazon US ([amazon.com](https://www.amazon.com/dp/B0BF5LKP5Q)).

# Tech inspection

Connected the device with the provided USB-C cable to my laptop (hardware). the operating system is Arch Linux (xserver+i3).

## Device

lsusb output lists 3 additional devices
```
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 002: ID 3318:0424 Nreal Nreal Air
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

getting more information about the device

```
lsusb -s 003:002 -v

Bus 003 Device 002: ID 3318:0424 Nreal Nreal Air
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x3318
  idProduct          0x0424
  bcdDevice            0.01
  iManufacturer           1 Nreal
  iProduct                2 Nreal Air
  iSerial                 3 A00011:14:14
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0121
    bNumInterfaces          6
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0
      iInterface              0
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength       0x0047
        bInCollection           2
        baInterfaceNr(0)        1
        baInterfaceNr(1)        2
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            1
        bmaControls(0)       0x03
          Mute Control
          Volume Control
        bmaControls(1)       0x00
        bmaControls(2)       0x00
        iFeature                0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0402 Headset
        bAssocTerminal          4
        bSourceID               2
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             4
        wTerminalType      0x0402 Headset
        bAssocTerminal          3
        bNrChannels             1
        wChannelConfig     0x0001
          Left Front (L)
        iChannelNames           0
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               4
        bControlSize            1
        bmaControls(0)       0x03
          Mute Control
          Volume Control
        bmaControls(1)       0x00
        iFeature                0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             6
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               5
        iTerminal               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag         0x0001 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes           13
          Transfer Type            Isochronous
          Synch Type               Synchronous
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioStreaming Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         2 Decoded PCM samples
          wLockDelay         0x0000
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           6
        bDelay                  1 frames
        wFormatTag         0x0001 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes           13
          Transfer Type            Isochronous
          Synch Type               Synchronous
          Usage Type               Data
        wMaxPacketSize     0x0068  1x 104 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioStreaming Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         2 Decoded PCM samples
          wLockDelay         0x0000
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      27
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      27
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x07  EP 7 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      27
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x09  EP 9 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
```

## Screen

Xrandr output:
```
DP1 connected (normal left inverted right x axis y axis)
   1920x1080     60.00 +
```

I can turn it on using xrandr from terminal or from [arandr](https://christian.amsuess.com/tools/arandr/) GUI. it supports only one mode with one resolution and one refresh rate.

![](/public/a48270d84c1be035b6f99ae30709e947ae64b5bd309d27dd5938dbf94983c7c1.png)

```
DP1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 120mm x 70mm
   1920x1080     60.00*+
```

what does the eDID look like

```
hexdump -C /sys/class/drm/card0-DP-1/edid
00000000  00 ff ff ff ff ff ff 00  3a 4c 32 31 00 88 88 88  |........:L21....|
00000010  08 1c 01 03 80 0c 07 78  0a 0d c9 a0 57 47 98 27  |.......x....WG.'|
00000020  12 48 4c 00 00 00 01 01  01 01 01 01 01 01 01 01  |.HL.............|
00000030  01 01 01 01 01 01 98 3a  80 50 70 38 aa 40 20 10  |.......:.Pp8.@ .|
00000040  95 00 80 38 74 00 00 1e  98 3a 80 50 70 38 aa 40  |...8t....:.Pp8.@|
00000050  20 10 95 00 80 38 74 00  00 1e 00 00 00 fd 00 32  | ....8t........2|
00000060  82 14 3c 3c 00 0a 20 20  20 20 20 20 00 00 00 fc  |..<<..      ....|
00000070  00 6e 72 65 61 6c 20 61  69 72 0a 20 20 20 00 5e  |.nreal air.   .^|
00000080
```

## Audio device

I'm a bit surprised as pulseaudio doesn't see the device! and can't find it in [Pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/) 

```
 ➜  cat /proc/asound/cards
 0 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xec340000 irq 140
```

# Pictures
![](/public/830cbead5788413f4396639d2a4fe16930df0f8b1c8f7d713834b64afffa2085.jpg)
![](/public/2f42bbb75702ecc6afa2f172996d3ebedecc83cdf20a416a07d475684f3915df.jpg)
![](/public/3d51026fbd92de79bd6d95817763aac4a82b85cb75a3af1faa14e4c5a2243fa3.jpg)
![](/public/8d7fce64fd67eeee3a17f166f221ad0622ad76a46aa6e810137476ebeee67d5f.jpg)
![](/public/7b15b2e3b85face801ec0c407b042728e4ebb7a5ef2501590bbf7b466d4d184f.jpg)
![](/public/1a1ff122d32af48707e08879d9fb616eae24f5ff4d1f02bbd29b0e60f980da95.jpg)

Couple things to note:

- in the picture the display looks curved. in reality it's straight not curved.
- in the pictures it appears out of focus. in reality some parts of the picture (mainly far corners) feels out of focus the rest if fine. and I found it changes when you move the device moves up or down.

# How does it work?

From what I'm seeing. 
- there is a small display at the top for each eye
- the display is horizontal facing down
- the top of the screen is near my eyes so rotating the glasses away from you makes the display in the correct orientation
- there is a glass from top near the eye bottom away to the edge fo glasses bottom. I guess this reflects the screen from one side. (one way mirror)
- the image falls on another glass infront of your eyes.

# How does it feel?

When looking at the displayed picture it feels really large looking at the ceiling with it feels like the cinema display. my eyes moves the same way to focus. with the center feels more focused and the edges and corners abit out of focus. my eye needs to move to look at the corners. 

# Devices

- Worked out of the box with Valve Steam deck
- Worked with my laptop
- Didn't work with my PC (same OS setup). as I connected it to the front USB-C of a lenovo usb dock. I guess I'll need HDMI to usbc adapter.

# Software

- Nebula is available for mac os https://www.nreal.ai/nebula
- I tried it on a Macbook pro M1 machine. it's a simple application where you can select if it's:
  -  1, 2, 3 screens.
  -  how far are they close, medium, far
  -  reset their position to face you in case your orientation changed
 
- I wanted to know what's inside it. downloaded it and extracted the dmg
```
pacman -S p7zip
7z x nebula.dmg
```
- the file structure
```
.
├── Applications
├── [HFS+ Private Data]
└── Nebula for Mac.app
    └── Contents
        ├── CodeResources
        ├── _CodeSignature
        │   └── CodeResources
        ├── Frameworks
        │   ├── GameAssembly.dylib
        │   └── UnityPlayer.dylib
        ├── Info.plist
        ├── MacOS
        │   └── Nebula
        ├── PlugIns
        │   ├── lib_burst_generated.bundle
        │   ├── libew.bundle
        │   │   └── Contents
        │   │       ├── _CodeSignature
        │   │       │   └── CodeResources
        │   │       ├── Info.plist
        │   │       ├── MacOS
        │   │       │   └── libew
        │   │       └── Resources
        │   │           ├── default.metallib
        │   │           ├── SettingViewController.nib
        │   │           └── TmpWindow.nib
        │   ├── libnr_api.dylib
        │   ├── libota.dylib
        │   ├── libth.bundle
        │   │   └── Contents
        │   │       ├── _CodeSignature
        │   │       │   └── CodeResources
        │   │       ├── Info.plist
        │   │       ├── MacOS
        │   │       │   └── libth
        │   │       └── Resources
        │   │           └── SensorsAnalyticsSDK.bundle
        │   │               ├── sa_autotrack_gestureview_blacklist.json
        │   │               ├── sa_autotrack_viewcontroller_blacklist.json
        │   │               ├── sa_mcc_mnc_mini.json
        │   │               ├── sa_visualized_path.json
        │   │               ├── sensors_analytics_flow.json
        │   │               ├── sensors_analytics_node.json
        │   │               ├── sensors_analytics_task.json
        │   │               └── zh-Hans.lproj
        │   │                   └── Localizable.strings
        │   └── libvdh.bundle
        │       └── Contents
        │           ├── _CodeSignature
        │           │   └── CodeResources
        │           ├── Info.plist
        │           ├── MacOS
        │           │   └── libvdh
        │           └── Resources
        │               ├── Assets.car
        │               └── MenuBarViewController.nib
        └── Resources
            ├── Data
            │   ├── app.info
            │   ├── boot.config
            │   ├── globalgamemanagers
            │   ├── globalgamemanagers.assets
            │   ├── globalgamemanagers.assets.resS
            │   ├── il2cpp_data
            │   │   ├── Metadata
            │   │   │   └── global-metadata.dat
            │   │   └── Resources
            │   │       ├── mscorlib.dll-resources.dat
            │   │       ├── Newtonsoft.Json.dll-resources.dat
            │   │       └── System.Data.dll-resources.dat
            │   ├── level0
            │   ├── level0.resS
            │   ├── Resources
            │   │   └── unity_builtin_extra
            │   ├── resources.assets
            │   ├── resources.assets.resS
            │   ├── RuntimeInitializeOnLoads.json
            │   ├── ScriptingAssemblies.json
            │   ├── sharedassets0.assets
            │   ├── sharedassets0.assets.resS
            │   └── StreamingAssets
            │       └── UnityServicesProjectConfiguration.json
            ├── DefaultPreferences.plist
            ├── MainMenu.nib
            │   ├── designable.nib
            │   └── keyedobjects.nib
            ├── PlayerIcon.icns
            └── unity default resources

32 directories, 56 files
```

Some notes:

- I see Unity library in the frameworks directory 