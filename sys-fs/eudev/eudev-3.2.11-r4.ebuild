# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KV_MIN=2.6.39

inherit autotools linux-info multilib-minimal toolchain-funcs

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/eudev-project/eudev.git"
	inherit git-r3
else
	SRC_URI="https://github.com/eudev-project/eudev/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://github.com/gentoo/eudev"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="+kmod introspection rule-generator selinux static-libs test"
RESTRICT="!test? ( test )"

DEPEND=">=sys-apps/util-linux-2.20
	>=sys-kernel/linux-headers-${KV_MIN}
	virtual/libcrypt:=
	introspection? ( >=dev-libs/gobject-introspection-1.38 )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd"
RDEPEND="${DEPEND}
	acct-group/input
	acct-group/kvm
	acct-group/render
	acct-group/audio
	acct-group/cdrom
	acct-group/dialout
	acct-group/disk
	acct-group/floppy
	acct-group/input
	acct-group/kmem
	acct-group/kvm
	acct-group/lp
	acct-group/render
	acct-group/sgx
	acct-group/tape
	acct-group/tty
	acct-group/usb
	acct-group/video
	!sys-apps/systemd-utils[udev]
	!sys-apps/systemd"
BDEPEND="dev-util/gperf
	virtual/os-headers
	virtual/pkgconfig
	>=dev-build/make-3.82-r4
	test? ( app-text/tree dev-lang/perl )"
PDEPEND=">=sys-fs/udev-init-scripts-26"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/udev.h
)

pkg_pretend() {
	ewarn
	ewarn "As of 2013-01-29, ${P} provides the new interface renaming functionality,"
	ewarn "as described in the URL below:"
	ewarn "https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames"
	ewarn
	ewarn "This functionality is enabled BY DEFAULT because eudev has no means of synchronizing"
	ewarn "between the default or user-modified choice of sys-fs/udev.  If you wish to disable"
	ewarn "this new iface naming, please be sure that /etc/udev/rules.d/80-net-name-slot.rules"
	ewarn "exists: touch /etc/udev/rules.d/80-net-name-slot.rules"
	ewarn
}

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~UNIX"
	linux-info_pkg_setup
	get_running_version

	# These are required kernel options, but we don't error out on them
	# because you can build under one kernel and run under another.
	if kernel_is lt ${KV_MIN//./ }; then
		ewarn
		ewarn "Your current running kernel version ${KV_FULL} is too old to run ${P}."
		ewarn "Make sure to run udev under kernel version ${KV_MIN} or above."
		ewarn
	fi
}

src_prepare() {
	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' -i rules/*.rules \
		|| die "failed to change group dialout to uucp"

	default
	eautoreconf
}

multilib_src_configure() {
	# bug #463846
	tc-export CC
	# bug #502950
	export cc_cv_CFLAGS__flto=no

	# Keep sorted by ./configure --help and only pass --disable flags
	# when *required* to avoid external deps or unnecessary compile
	local econf_args
	econf_args=(
		ac_cv_search_cap_init=
		ac_cv_header_sys_capability_h=yes
		DBUS_CFLAGS=' '
		DBUS_LIBS=' '
		--with-rootprefix=
		--with-rootrundir=/run
		--exec-prefix="${EPREFIX}"
		--bindir="${EPREFIX}"/bin
		--includedir="${EPREFIX}"/usr/include
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--with-rootlibexecdir="${EPREFIX}"/lib/udev
		--enable-split-usr
		--enable-manpages
	)

	# Only build libudev for non-native_abi, and only install it to libdir,
	# that means all options only apply to native_abi
	if multilib_is_native_abi; then
		econf_args+=(
			--with-rootlibdir="${EPREFIX}"/$(get_libdir)
			$(use_enable introspection)
			$(use_enable kmod)
			$(use_enable static-libs static)
			$(use_enable selinux)
			$(use_enable rule-generator)
		)
	else
		econf_args+=(
			--disable-static
			--disable-introspection
			--disable-kmod
			--disable-selinux
			--disable-rule-generator
			--disable-hwdb
		)
	fi

	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
	else
		emake -C src/shared
		emake -C src/libudev
	fi
}

multilib_src_test() {
	# make sandbox get out of the way
	# these are safe because there is a fake root filesystem put in place,
	# but sandbox seems to evaluate the paths of the test i/o instead of the
	# paths of the actual i/o that results.
	# also only test for native abi
	if multilib_is_native_abi; then
		addread /sys
		addwrite /dev
		addwrite /run

		default_src_test
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake -C src/libudev DESTDIR="${D}" install
	fi
	rm -f "${D}/sbin/udevadm"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/40-gentoo.rules

	use rule-generator && doinitd "${FILESDIR}"/udev-postmount
}

pkg_postinst() {
	mkdir -p "${EROOT}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${EROOT}"/dev/loop 2>/dev/null
	if [[ -d ${EROOT}/dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	# REPLACING_VERSIONS should only ever have zero or 1 values but in case it doesn't,
	# process it as a list.  We only care about the zero case (new install) or the case where
	# the same version is being re-emerged.  If there is a second version, allow it to abort.
	local rv rvres=doitnew
	for rv in ${REPLACING_VERSIONS} ; do
		if [[ ${rvres} == doit* ]]; then
			if [[ ${rv%-r*} == ${PV} ]]; then
				rvres=doit
			else
				rvres=${rv}
			fi
		fi
	done

	if has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT}"

		# https://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		# reload database after it has be rebuilt, but only if we are not upgrading
		# also pass if we are -9999 since who knows what hwdb related changes there might be
		if [[ ${rvres} == doit* ]] && [[ -z ${ROOT} ]] && [[ ${PV} != "9999" ]]; then
			udevadm control --reload
		fi
	fi

	if [[ ${rvres} != doitnew ]]; then
		ewarn
		ewarn "You need to restart eudev as soon as possible to make the"
		ewarn "upgrade go into effect:"
		ewarn "\t/etc/init.d/udev --nodeps restart"
	fi

	if use rule-generator && \
	[[ -x $(type -P rc-update) ]] && rc-update show | grep udev-postmount | grep -qsv 'boot\|default\|sysinit'; then
		ewarn
		ewarn "Please add the udev-postmount init script to your default runlevel"
		ewarn "to ensure the legacy rule-generator functionality works as reliably"
		ewarn "as possible."
		ewarn "\trc-update add udev-postmount default"
	fi

	elog
	elog "For more information on eudev on Gentoo, writing udev rules, and"
	elog "fixing known issues visit: https://wiki.gentoo.org/wiki/Eudev"
}
