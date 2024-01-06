# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="gentoo specific daemontools wrapper scripts"
HOMEPAGE="https://fixme"
SRC_URI="https://github.com/rodan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static selinux withsamplescripts"

RDEPEND="selinux? ( sys-apps/policycoreutils )"
DEPEND=""
RESTRICT="mirror"

src_compile() {
	use static && append-ldflags -static

	make -C "${S}/src" CC="$(tc-getCC)" LD="$(tc-getCC) ${LDFLAGS}" \
		CFLAGS="${CFLAGS}" || die
}

pkg_setup() {

	use withsamplescripts && ( echo "${CONFIG_PROTECT}" | grep '/var/service' >/dev/null || \
		if [ -d /var/service ]; then
			ewarn ""
			ewarn "PLEASE NOTE: You are currently using /var/service for"
			ewarn "some daemontools services."
			ewarn "In order to avoid damages to your system, please run"
			ewarn ""
			ewarn "echo 'CONFIG_PROTECT=\"/var/service\"' > /etc/env.d/51svcinit"
			ewarn "env-update"
			ewarn "source /etc/profile"
			ewarn ""
		fi
	)

}

src_install() {
	into /
	doenvd etc/env.d/50svcinit
	dosbin sbin/* || die
	dosbin src/svcinit || die

	# usage() script
	exeinto /$(get_libdir)/rcscripts/sh
	doexe lib/rcscripts/sh/* || die

	if use withsamplescripts ; then

		# fill up /var/service/*
		keepdir /var/service

		cd "${S}"/var/service

		services=`find ./ -type d`
		for service in ${services}; do
			dodir /var/service/${item}
		done

		files=`find ./ -type f`
		for file in ${files}; do
			path=`dirname ${file}`
			exeinto /var/service/${path}
			doexe ${file}
		done
	fi
}
