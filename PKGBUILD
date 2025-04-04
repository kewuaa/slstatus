pkgname=slstatus-dwl
pkgver="0.1.0"
pkgrel=1
arch=("x86_64")
depends=(
    "alsa-lib"
)
makedepends=("gcc" "make")


build() {
    cd ${srcdir}/..
    make clean
    make
}


package() {
    cd ${srcdir}/..
    make DESTDIR="${pkgdir}" PREFIX="/usr" install
}
