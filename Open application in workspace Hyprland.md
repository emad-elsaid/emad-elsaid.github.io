I wanted to open couple applications when I start my machine. and I want each application to open in specific workspace.

the following ruby script will do that. it will run the command and wait for a window to appear, then moves it to the workspace. it'll try to do that 50 times and waits for 0.1 second between tries. so if the command is wrong for example the script will exit after 5 seconds anstead of stucking.

```ruby
#!/usr/bin/env ruby

require 'json'

command = ARGV.shift
workspace = ARGV.shift

pid = Process.fork
if pid.nil?
  exec command
else
  Process.detach(pid)

  50.times do
    windows = JSON.parse `hyprctl clients -j`
    found = windows.any? { |win| win['pid'] == pid }
    if found
      `hyprctl dispatch movetoworkspace "#{workspace},pid:#{pid}"`
      break
    end

    sleep 0.1
  end
end
```

I use it in my hyprland config as follows:

```conf
exec-once = open-in-workspace emacs 1
exec-once = open-in-workspace kitty 2
exec-once = open-in-workspace google-chrome-stable 3
exec-once = open-in-workspace slack 4
```

I was doing these steps manually everytime I start my machine in the morning. this script will save me a bit of effort.

# Edit

turns out Hyprland has a syntax to open the application in a specific workspace. knew it from an [issue on github](https://github.com/hyprwm/Hyprland/discussions/982).

```conf
exec-once = [workspace 1 silent] emacs
exec-once = [workspace 2 silent] kitty
exec-once = [workspace 3 silent] google-chrome-stable
exec-once = [workspace 4 silent] slack
```

#hyprland #linux #archlinux
