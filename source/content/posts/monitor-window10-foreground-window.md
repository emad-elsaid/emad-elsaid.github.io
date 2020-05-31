---
title: "Monitor Window10 Foreground Window"
date: 2020-05-31T11:16:43+02:00
---

On my windows10 gaming machine I often has this problem were I'm playing a game
in fullscreen and it's minimized randomly, no other application appears on the
screen.

I thought that this must be another application stealing the focus from the
game, but I had no way of verifying my claim so I had to write a small script
that runs in windows powershell ISE that prints the focused window all the time
and the window process.

```
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

while($TRUE)
{
    $a = [tricks]::GetForegroundWindow()
    get-process | ? { $_.mainwindowhandle -eq $a }
    sleep 1
}
```

And guess who was the criminal? it was Origin store, the single application that
I can't close because the it's required to run the game itself.
