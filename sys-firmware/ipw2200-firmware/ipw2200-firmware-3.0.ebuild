# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/firmware/fw}

DESCRIPTION="Firmware for the Intel PRO/Wireless 2200BG/2915ABG miniPCI, 2225BG PCI adapters"
HOMEPAGE="http://ipw2200.sourceforge.net/"
SRC_URI="http://distfiles.simplex.ro/${MY_P}.tgz"
S=${WORKDIR}/${MY_P}

LICENSE="ipw2200-fw"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	insinto /lib/firmware
	doins ipw2200-{bss,ibss,sniffer}.fw
}
