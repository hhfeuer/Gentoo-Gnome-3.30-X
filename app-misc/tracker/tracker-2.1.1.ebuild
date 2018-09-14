# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit bash-completion-r1 eutils meson gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="elibc_glibc seccomp stemmer test "

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# According to NEWS, introspection is non-optional
# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
# seccomp is automagic, though we want to use it whenever possible (linux)
# >=media-libs/libmediaart-1.9:2.0 is suggested to be disabled for 1.10 for security;
# It is disable in configure in 1.12; revisit for 1.14/2 (configure flag)
RDEPEND="
	>=app-i18n/enca-1.9
	>=dev-db/sqlite-3.20:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=dev-libs/json-glib-1.0
	>=media-libs/libpng-1.2:0=
	>=net-libs/libsoup-2.40:2.4
	>=x11-libs/pango-1:=
	sys-apps/util-linux
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	>=x11-libs/gtk+-3:3
	stemmer? ( dev-libs/snowball-stemmer )
	seccomp? ( >=sys-libs/libseccomp-2.0 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"
function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare
	eapply_user
}

src_configure() {
        local emesonargs=(
		-Dbash_completion="$(get_bashcompdir)"
                -Dstemmer=$(usex stemmer yes no)
        )
	meson_src_configure
}

src_test() {
	# G_MESSAGES_DEBUG, upstream bug #699401#c1
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session" G_MESSAGES_DEBUG="all"
}

src_install() {
	meson_src_install
}
