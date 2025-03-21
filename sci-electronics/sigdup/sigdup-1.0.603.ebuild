# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="1.0b603"
#MY_PV="62767181b05a2e6d05d99fba80c0dbeb78d7294c"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="sigdup - replay PulseView digital signals on the pins of a microcontroller"
HOMEPAGE="https://codeberg.org/subDIMENSION/sigdup"
SRC_URI="https://codeberg.org/subDIMENSION/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${PN}/software/sigdup

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="dev-libs/libzip"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i '/CONFIG_DEBUG/d' config.h || die
	use debug && echo '#define CONFIG_DEBUG' >> config.h
}

src_install() {
	exeinto /usr/bin/
	doexe "${PN}"
	doman "../../doc/sigdup-firmware.1"
	doman "../../doc/sigdup.1"
}
