# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="30dd40f4fb"

DESCRIPTION="a stdio to tcp redirector daemon"
HOMEPAGE="https://codeberg.org/subDIMENSION/iotcpd"
SRC_URI="https://codeberg.org/subDIMENSION/${PN}/archive/${MY_PN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}/server"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="x11-misc/makedepend"

src_install() {
	doman "${S}/../doc/iotcpd.1"

	exeinto "usr/sbin"
	doexe iotcpd
}
