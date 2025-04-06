* Install using `pacman -S qutebrowser`
* Had to add a line to the configuration pythong file `~/.config/qutebrowser/config.yml` `config.load_autoconfig()` because it was empty. after changing any config using the UI and restarting it won't work until you add this line.
* Added Dracula theme to match the rest of the system by copying this file content: `https://github.com/dracula/qutebrowser/blob/master/draw.py` inside `config.yml` and add this block after it:
```python
blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})
```
* Opening any webpage that uses webgl like `github.com` home page (before you login). will freeze it on Nvidia (didn't happen on the laptop with builtin GPU). fixed by forcing software rendering by setting:
```yaml
  qt.force_software_rendering:
    global: chromium
```
* to make sure it only works on the nvidia machines not the rest of my machines, I removed it and added this to `config.py`
```yaml
if os.environ.get("GBM_BACKEND") == "nvidia":
    c.qt.force_software_rendering = "chromium"
```

 * I have a muscle memory on `ctrl+t` and `ctrl+w` to open new tab and close existing tab. `ctrl+w` already works. so lets fix `ctrl+t`
```yaml
config.bind("<Ctrl+t>","cmd-set-text -s :open -t")
```
