# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="atlas430"
#MY_PV="${PV}"
MY_PV="5719ae5f2250a05d10ede41f61219f1553d31c4f"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="library of HAL functions for MSP430 microcontrollers"
HOMEPAGE="https://codeberg.org/subDIMENSION/atlas430"
SRC_URI="https://codeberg.org/subDIMENSION/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="strip"

keep_perms="
opt/atlas430/lib/libmsp430-3.15.01.001.so
"

src_compile() {
	:
}

src_install() {

	insinto "/opt/atlas430/lib"
	doins lib/Linux/libmsp430-3.15.01.001.so
	doins lib/Linux/libmsp430.so

	rm -rf "${D}"/lib/Linux || die
	rm -rf "${D}"/lib/FreeBSD || die

	insinto "/opt/atlas430"
	doins -r doc
	doins -r driverlib
	doins -r drivers
	doins -r tests
	doins -r tools
	doins LICENSE
	doins Makefile
	doins Makefile.env
	doins Makefile.identify-target
	doins Makefile.libatlas430
	doins README.md

	for f in ${keep_perms}; do
		fperms +x "/${f}"
	done
}
