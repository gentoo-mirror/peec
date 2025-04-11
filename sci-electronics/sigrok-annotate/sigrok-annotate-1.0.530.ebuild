# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="1.0b530"
#MY_PV="62767181b05a2e6d05d99fba80c0dbeb78d7294c"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="decode and annotate a sigrok signal capture"
HOMEPAGE="https://codeberg.org/subDIMENSION/sigrok-annotate"
SRC_URI="https://codeberg.org/subDIMENSION/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${PN}/src

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="dev-libs/glib"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i '/CONFIG_DEBUG/d' config.h || die
	use debug && echo '#define CONFIG_DEBUG' >> config.h
}

src_install() {
	exeinto /usr/bin/
	doexe "${PN}"
	doman "../doc/sigrok-annotate.1"
}
