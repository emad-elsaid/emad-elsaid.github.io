#archlinux

* This page was very useful https://madskjeldgaard.dk/posts/aur-package-workflow/
* Example from Xlog PKGBUILD, published to AUR: https://aur.archlinux.org/packages/xlog-git
* To build package locally `makepkg -s`
* To build and install `makepkg -si`
* To create .SRCINFO file `makepkg --printsrcinfo > .SRCINFO`
* Git remote url: `ssh://aur@aur.archlinux.org/xlog-git.git` 

```bash
# Maintainer: Emad Elsaid <emad.elsaid.hamed@gmail.com>
pkgname=xlog-git
_pkgname="xlog"
pkgver=0.41.0.r5.gf79e299
pkgrel=1
pkgdesc="Xlog is a static site generator for digital gardening written in Go"
arch=('i686' 'pentium4' 'x86_64' 'arm' 'armv6h' 'armv7h' 'aarch64')
url="https://github.com/emad-elsaid/xlog"
license=('MIT')
depends=('git')
makedepends=('go>=1.19')
provides=('xlog')
conflicts=('xlog')
source=(xlog::git+https://github.com/emad-elsaid/xlog.git#branch=master)
sha256sums=("SKIP")

pkgver() {
    cd "$srcdir/$_pkgname"
    git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
    export GOPATH="$srcdir"/gopath
    cd "$srcdir/$_pkgname"
    go build -modcacherw -o xlog ./cmd/xlog
}

package() {
    cd "$srcdir/$_pkgname"
    install -Dm755 xlog $pkgdir/usr/bin/xlog
}
```