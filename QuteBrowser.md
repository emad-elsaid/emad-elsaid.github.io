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
```python
if os.environ.get("GBM_BACKEND") == "nvidia":
    c.qt.force_software_rendering = "chromium"
```

 * I have a muscle memory on `ctrl+t` and `ctrl+w` to open new tab and close existing tab. `ctrl+w` already works. so lets fix `ctrl+t`
```python
config.bind("<Ctrl+t>","cmd-set-text -s :open -t")
```
* Changing the default search engine to google (in autoconfig.yaml).
```yaml
  url.searchengines:
    global:
      DEFAULT: https://www.google.com/search?q={}
```
 * I wrote in My ideal browser. that I want no UI around the page whatsoevery. so hiding the tab and status bar and any window decoration.
```yaml
  tabs.show:
    global: never
  statusbar.show:
    global: never
```
 * Change the default editor from `gvim` to `emacs`
```yaml
  editor.command:
    global:
    - emacsclient
    - -n
    - -a
    - +{line}:{column0}
    - '{file}'
```

# Issues
* Camera and Microphone doesn't work. the browser doesn't show the permission dialog
* Sometimes I expect the page to be in insert mode like when there is a blinking cursor. but some websites fake it or something. maybe that's the issue?
* In Gmail I have keyboard shortcuts enabled, but I have to remember to get to insert mode first before using them.
