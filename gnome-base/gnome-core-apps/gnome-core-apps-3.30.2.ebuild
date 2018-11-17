# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth +cdr cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~x86"

# Note to developers:
# This is a wrapper for the core apps tightly integrated with GNOME 3
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.30.0
	>=gnome-base/gnome-settings-daemon-3.30.0[cups?]
	>=gnome-base/gnome-control-center-3.30.0[cups?]

	>=app-crypt/gcr-3.28.0
	>=gnome-base/nautilus-3.26.4
	>=gnome-base/gnome-keyring-3.28.0
	>=gnome-extra/evolution-data-server-3.30.0

	>=app-crypt/seahorse-3.20.0
	>=app-editors/gedit-3.30.0
	>=app-text/evince-3.30.0
	>=gnome-extra/gnome-contacts-3.30
	>=media-gfx/eog-3.28.3
	>=media-video/totem-3.26.2
	>=x11-terms/gnome-terminal-3.30.0

	>=gnome-extra/gnome-user-docs-3.30.0
	>=gnome-extra/yelp-3.30.0

	>=x11-themes/adwaita-icon-theme-3.30.0
	>=x11-themes/gnome-themes-standard-3.22.3

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.28.0 )
	cdr? ( >=app-cdr/brasero-3.12.2 )

	!gnome-base/gnome-applets
"
DEPEND=""

# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions
# >=net-im/empathy-3.12.12 # not part of gnome releng core or apps suite anymore

S="${WORKDIR}"
