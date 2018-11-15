Unofficial Gentoo Gnome 3.30 on Xorg overlay
--------------------------------------------

Versions
--------

 - Gnome 3.30 (stable)

General information
-------------------

 - Does not need the Gnome 3.28 overlay
 - All ebuilds are keyworded amd64
 - Only contains dependencies for and tested with USE="-wayland"
 - Updated games not (yet) included
 - Portions taken from the Heather Gnome overlay
 - ebuilds derived from the 3.22/24 official Gentoo portage ebuilds

Usage
-----

## via local overlays

Create a `/etc/portage/repos.conf/Gnome-3.30-X.conf` file containing

```
[Gnome-3-30-X]
location = /usr/local/portage/Gnome-3-30-X
sync-type = git
sync-uri = https://github.com/hhfeuer/Gentoo-Gnome-3.30-X.git
priority=9999
```

Then run emerge --sync

## via layman

Add via layman:

	layman -o https://raw.github.com/hhfeuer/Gentoo-Gnome-3.30-X/master/repositories.xml -f -a Gnome-3-30-X

Then run layman -s Gnome-3-30-X

Desktop Icons
-------------
As of Version 3.28, nautilus has dropped support for Desktop Icons. To get them back either use package.mask

	>=gnome-base/nautilus-3.28.1
	>=gnome-extra/gnome-user-share-3.28.0

to stay on nautilus-3.26.x or use the experimental gnome-shell plugin at:

	https://gitlab.gnome.org/csoriano/org.gnome.desktop-icons

Another possiblity would be using nemo from the Cinnamon desktop which is a natilus fork.


Needs
-----
needs package.unmask:

	=app-text/libgepub-0.6.0

package.keywords/accept_keywords:

	=x11-libs/gtk+-3.24.1 ~amd64
	=media-libs/grilo-0.3.6 ~amd64
	=media-libs/babl-0.1.56 ~amd64
	=media-libs/gegl-0.4.8-r1 ~amd64
	=app-text/gspell-1.6.1 ~amd64
	=dev-util/meson-0.47.1 ~amd64
	=sys-power/upower-0.99.7 ~amd64
	=dev-lang/spidermonkey-52.9.1_pre1 ~amd64
	=sys-fs/udisks-2.8.0 ~amd64
	=sys-auth/polkit-0.115-r1 ~amd64
	=sys-libs/libblockdev-2.19 ~amd64

needs package.use:

	dev-libs/folks -tracker
	>=x11-libs/gtksourceview-3.24.7 vala
	>=net-libs/gnome-online-accounts-3.26.2 vala

depending on kernel config might need package.use:

	sys-apps/bubblewrap suid

if portage is complaining about blocks concerning glib and gdbus-codegen, run first:

	emerge -1 glib gdbus-codegen


