# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Petre Rodan"
HOMEPAGE="https://subdimension.ro"
SRC_URI="https://openpgpkey.subdimension.ro/.well-known/openpgpkey/subdimension.ro/hu/hdcbgy7z3k5fbfpn6ux8zaydhso5qoqt -> ${P}.gpg"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/${P}.gpg ${PN##openpgp-keys-}.gpg
}
