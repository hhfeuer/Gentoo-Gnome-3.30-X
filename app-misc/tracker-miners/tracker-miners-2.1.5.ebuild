# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit eutils meson gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="Miner plugins for Tracker"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="elibc_glibc gstreamer +miner-fs seccomp test cue exif ffmpeg
 flac gif gsf gstreamer gtk iptc +iso +jpeg libav mp3 pdf ps
 playlist rss +tiff upnp-av upower +vorbis +xml xmp xps"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# According to NEWS, introspection is non-optional
# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
# seccomp is automagic, though we want to use it whenever possible (linux)
# >=media-libs/libmediaart-1.9:2.0 is suggested to be disabled for 1.10 for security;
# It is disable in configure in 1.12; revisit for 1.14/2 (configure flag)
RDEPEND="
	>=app-misc/tracker-2.1
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
	seccomp? ( >=sys-libs/libseccomp-2.0 )
	virtual/imagemagick-tools[png,jpeg?]

	cue? ( media-libs/libcue )
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib:= )
	gsf? ( >=gnome-extra/libgsf-1.14.24 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	gtk? (
		>=x11-libs/gtk+-3:3 )
	iptc? ( media-libs/libiptcdata )
	iso? ( >=sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( >=media-libs/taglib-1.6 )
	pdf? (
		>=x11-libs/cairo-1:=
		>=app-text/poppler-0.16[cairo,utils]
		>=x11-libs/gtk+-2.12:2 )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	rss? ( >=net-libs/libgrss-0.7:0 )
	tiff? ( media-libs/tiff:0 )
	upnp-av? ( >=media-libs/gupnp-dlna-0.9.4:2.0 )
	vorbis? ( >=media-libs/libvorbis-0.22 )
	xml? ( >=dev-libs/libxml2-2.6 )
	xmp? ( >=media-libs/exempi-2.1 )
	xps? ( app-text/libgxps )
	!gstreamer? ( !ffmpeg? ( || ( media-video/totem media-video/mplayer ) ) )
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
		-Dextract=true
		$(meson_use test functional_tests)
		-Dguarantee_metadata=true
		-Dminer_apps=true
		$(meson_use miner-fs miner_fs)
		$(meson_use rss miner_rss)
		-Dwriteback=true
		-Dabiword=true
		-Ddvi=true
		-Dicon=true
		$(meson_use mp3)
		-Dps=true
		-Dtext=true
		-Dunzip_ps_gz_files=true
		-Dbattery_detection=$(usex upower upower auto)
	)
#	if use gstreamer ; then
#		emesonargs="${emesonargs} -Dgeneric_media_extractor=gstreamer"
#		if use upnp-av; then
#			emesonargs="${emesonargs} -Dgstreamer_backend=gupnp"
#		else
#			emesonargs="${emesonargs} -Dgstreamer_backend=discoverer"
#	fi
#	elif use ffmpeg ; then
#		emesonargs="${emesonargs} -Dgeneric_media_extractor==libav"
#	else
#		emesonargs="${emesonargs} -Dgeneric_media_extractor=none"
#	fi

	meson_src_configure
}

src_test() {
	# G_MESSAGES_DEBUG, upstream bug #699401#c1
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session" G_MESSAGES_DEBUG="all"
}

src_install() {
	meson_src_install
	if use !rss ; then
		rm ${D}/usr/share/tracker/miners/org.freedesktop.Tracker1.Miner.RSS.service
	fi
}
