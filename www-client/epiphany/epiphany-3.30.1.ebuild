# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 virtualx meson

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.52.0:2[dbus]
	>=x11-libs/gtk+-3.22.13:3
	>=net-libs/webkit-gtk-2.22.0:4=
	>=x11-libs/cairo-1.2
	>=app-crypt/gcr-3.5.5:=[gtk]
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=dev-libs/nettle-3.2
	dev-libs/icu:=
	>=x11-libs/libnotify-0.5.1:=
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48:2.4
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	dev-db/sqlite:3
	>=app-text/iso-codes-0.35
	>=gnome-base/gsettings-desktop-schemas-0.0.1
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	sys-apps/paxctl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=751591
	"${FILESDIR}"/${PN}-3.16.0-unittest-1.patch

	# https://bugzilla.gnome.org/show_bug.cgi?id=751593
	"${FILESDIR}"/${PN}-3.14.0-unittest-2.patch
)

MESON_BUILD_DIR="${WORKDIR}/${P}_mesonbuild"

src_prepare() {
	mkdir -p "${MESON_BUILD_DIR}" || die
	default
}

meson_use_enable() {
	echo "-Denable-${2:-${1}}=$(usex ${1} 'true' 'false')"
}

src_configure() {
	local myconf=(
		--buildtype=plain
		--libdir="$(get_libdir)"
		--localstatedir="${EPREFIX}/var"
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
#		-Doption=enable-shared
#		-Doption=disable-static
#		-Doption=disable-update-mimedb
		$(meson_use test unit_tests)
	)
	set -- meson "${myconf[@]}" "${S}" "${MESON_BUILD_DIR}"
	echo "$@"
	"$@" || die
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	fi
	set -- ninja -v ${NINJAOPTS} -C "${MESON_BUILD_DIR}" "${@}"
	echo "${@}"
	"${@}" || die
}

src_compile() {
	eninja
}

src_install() {
	DESTDIR="${ED%/}" eninja install
}

