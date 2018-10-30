# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="Podcast app for GNOME"
HOMEPAGE="https://gitlab.gnome.org/World/podcasts"
SRC_URI="https://gitlab.gnome.org/World/podcasts/-/archive/${PV}/podcasts-${PV}.tar.gz"
RESTRICT="network-sandbox"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd amd64-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/libhandy
"

RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	!<gnome-extra/gnome-utils-3.4
"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/podcasts-${PV}"
BUILD_DIR="${S}/build"
