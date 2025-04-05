The documentation in [this page](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md) mention that you shouldn't git clone it but download a set of tools that will do that for you. 

```sh
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="${HOME}/code/depot_tools:$PATH" # the repo is in ~/code change it to your path.
```

Now you should get the repo. there ara two commands, once clones the whole repo + history (52GB) another will pull just the latest version of the code (23GB). and interruptions are not recoverable so make sure you choose the command that you're comfortable with redoing if a failure happens.
```sh
mkdir chromium && cd chromium
fetch --nohooks chromium # full clone with history
fetch --nohooks --no-history chromium # without history (faster)
```

install dependencies needed to compile. it takes hours on my machine, so take a walk, touch grass.
```sh
sudo pacman -S --needed python perl gcc gcc-libs bison flex gperf pkgconfig \
nss alsa-lib glib2 gtk3 nspr freetype2 cairo dbus xorg-server-xvfb \
xorg-xdpyinfo
```

Then we compile.
```sh
gclient runhooks
cd src
gn gen out/Default
autoninja -C out/Default chrome
```

Run chrome
```sh
./out/Default/chrome
```
