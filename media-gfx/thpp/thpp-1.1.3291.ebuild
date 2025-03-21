# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

IMGUI_PN="imgui"
IMGUI_PV="15b96fd051731254f4ed0ef78c183f3466bf9e1f"
IMGUI_P="${IMGUI_PN}-${IMGUI_PV}"

IMPLOT_PN="implot"
IMPLOT_PV="47522f47054d33178e7defa780042bd2a06b09f9"
IMPLOT_P="${IMPLOT_PN}-${IMPLOT_PV}"

LODEPNG_PN="lodepng"
LODEPNG_COMMIT="0b1d9ccfc2093e5d6620cd9a11d03ee6ff6705f5"
LODEPNG_P="${LODEPNG_PN}-${LODEPNG_COMMIT}"

TINYTIFF_PN="TinyTIFF"
TINYTIFF_PV="4.0.1.0"
TINYTIFF_P="${TINYTIFF_PN}-${TINYTIFF_PV}"

#MY_PV="${PV}"
#MY_PV="af08c89043604f5e496ce355e1ad05dbf6a8f038"
MY_PV="1.1b3291"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Thermal Processing Panel - a viewer and analyzer of infrared images"
HOMEPAGE="https://codeberg.org/subDIMENSION/thpp"
SRC_URI="https://codeberg.org/subDIMENSION/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/ocornut/${IMGUI_PN}/archive/${IMGUI_PV}.tar.gz -> ${IMGUI_P}.tar.gz
	https://github.com/epezent/${IMPLOT_PN}/archive/${IMPLOT_PV}.tar.gz -> ${IMPLOT_P}.tar.gz
	https://github.com/jkriege2/${TINYTIFF_PN}/archive/${TINYTIFF_PV}.tar.gz -> ${TINYTIFF_P}.tar.gz
	https://github.com/lvandeve/${LODEPNG_PN}/archive/${LODEPNG_COMMIT}.tar.gz -> ${LODEPNG_P}.tar.gz
"
S="${WORKDIR}/${PN}/src"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="media-libs/libglvnd
	media-libs/glfw
	sys-devel/gcc:*[openmp]"
RDEPEND="${DEPEND}
	media-libs/exiftool"

src_unpack() {
	unpack ${MY_P}.tar.gz || die "Unpacking ${P}.tar.gz failed"
	cd "${S}/../lib" || die "Unpack incomplete"
	unpack ${IMGUI_P}.tar.gz || die "Unpacking ${IMGUI_P}.tar.gz failed"
	unpack ${IMPLOT_P}.tar.gz || die "Unpacking ${IMPLOT_P}.tar.gz failed"
	unpack ${TINYTIFF_P}.tar.gz || die "Unpacking ${TINYTIFF_P}.tar.gz failed"
	unpack ${LODEPNG_P}.tar.gz || die "Unpacking ${LODEPNG_P}.tar.gz failed"
	rm -rf imgui TinyTIFF implot lodepng
	ln -s "${IMGUI_P}" imgui
	ln -s "${TINYTIFF_P}" TinyTIFF
	ln -s "${IMPLOT_PN}-${IMPLOT_PV}" implot
	ln -s "${LODEPNG_P}" lodepng
}

src_prepare() {
	default
	sed -i '/CONFIG_DEBUG/d' config.h || die
	use debug && echo '#define CONFIG_DEBUG' >> config.h
}

src_install() {
	insinto /usr/share/thpp
	dodir /usr/share/thpp
	newins res/dir_icon.png dir_icon.png
	newins res/file_icon.png file_icon.png
	newins res/imgui.ini imgui.ini

	exeinto /usr/bin/
	doexe "${S}/${PN}"
}
