# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools linux-info

DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/projectatomic/bubblewrap"
SRC_URI="https://github.com/projectatomic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE="suid selinux"

DEPEND="
        sys-libs/libseccomp
"

RDEPEND="${DEPEND}"

pkg_setup() {
    ERROR_USER_NS="CONFIG_USER_NS is not set in kernel config, be sure to have  USE=\"suid\" set for bubblewrap"
    CONFIG_CHECK="~USER_NS"
    check_extra_config
}

src_prepare() {
    eautoreconf
}

src_configure() {
    local myconf
    if ! use selinux; then myconf+=" --disable-selinux"; fi
    if use suid; then
        myconf+=" --with-priv-mode=setuid"
    fi
    econf ${myconf}
}

src_install() {
    make DESTDIR="${D}" install || die
}
