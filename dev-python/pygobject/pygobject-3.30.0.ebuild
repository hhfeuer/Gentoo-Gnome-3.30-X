# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit eutils gnome2 meson python-r1 virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cairo examples +threads"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.46.0:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.10.0[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
	test? (
		dev-libs/atk[introspection]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-libs/cairo[glib]
		x11-libs/gdk-pixbuf:2[introspection,jpeg]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
		python_targets_python2_7? ( dev-python/pyflakes[$(python_gen_usedep python2_7)] ) )
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"

src_prepare() {
	sed -e 's/^.*type(font_opts.get_subpixel_order()), int.*/#/' \
		-i tests/test_cairo.py || die

	gnome2_src_prepare
}

src_configure() {
	configuring() {
		BUILD_DIR=${WORKDIR}/build-${EPYTHON}
		mkdir -p ${BUILD_DIR}
		meson_src_configure -Dpython=${EPYTHON}

		# Pyflakes tests work only in python2, bug #516744
		if use test && [[ ${EPYTHON} != python2.7 ]]; then
			sed -e 's/if type pyflakes/if false/' \
				-i Makefile || die "sed failed"
		fi
	}

	python_foreach_impl configuring
}

src_compile() {
	compiling() {
                BUILD_DIR=${WORKDIR}/build-${EPYTHON}
		meson_src_compile
	}
	python_foreach_impl compiling
}

src_test() {
	local -x GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs
	local -x GIO_USE_VOLUME_MONITOR="unix" # prevent udisks-related failures in chroots, bug #449484
	local -x SKIP_PEP8="yes"

	testing() {
		local -x XDG_CACHE_HOME="${T}/${EPYTHON}"
		emake -C "${BUILD_DIR}" check
	}
	virtx python_foreach_impl testing
}

src_install() {
	installing() {
                BUILD_DIR=${WORKDIR}/build-${EPYTHON}
		meson_src_install
	}
	python_foreach_impl installing

	dodoc -r examples
}
