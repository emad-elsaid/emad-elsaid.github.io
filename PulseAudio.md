Controlling PulseAudio from terminal 

```shell
pactl set-sink-volume 0 +10% # raise volume by 10%
pactl set-sink-volume 0 -10% # lower volume by 10%
pactl set-sink-mute 0 toggle # mute/unmute 
```

If using i3 , config can be

```conf
bindsym XF86AudioRaiseVolume exec "pactl set-sink-volume 0 +10%"
bindsym XF86AudioLowerVolume exec "pactl set-sink-volume 0 -10%"
bindsym XF86AudioMute exec "pactl set-sink-mute 0 toggle"
```