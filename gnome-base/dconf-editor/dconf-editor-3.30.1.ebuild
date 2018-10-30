# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.40"

inherit gnome2 vala meson

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~arm-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.46.0:2
	>=gnome-base/dconf-0.25.1
	>=x11-libs/gtk+-3.22.0:3
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	>=dev-lang/vala-0.40:0.40
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"

src_prepare() {
	vala_src_prepare
	default
}
