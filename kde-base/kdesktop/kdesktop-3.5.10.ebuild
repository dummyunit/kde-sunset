# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesktop/kdesktop-3.5.10.ebuild,v 1.7 2009/07/12 13:18:12 armin76 Exp $

EAPI="1"
KMNAME=kdebase
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-13.tar.bz2"

DESCRIPTION="KDesktop is the KDE interface that handles the icons, desktop popup menus and screensaver system."
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility xscreensaver"

DEPEND="x11-libs/libXext
	x11-libs/libXcursor
	>=kde-apps/libkonq-${PV}:${SLOT}
	>=kde-apps/kcontrol-${PV}:${SLOT}
	xscreensaver? ( x11-proto/scrnsaverproto )"
	# Requires the desktop background settings module,
	# so until we separate the kcontrol modules into separate ebuilds :-),
	# there's a dep here
RDEPEND="${DEPEND}
	>=kde-base/kcheckpass-${PV}:${SLOT}
	>=kde-apps/kdialog-${PV}:${SLOT}
	>=kde-apps/konqueror-${PV}:${SLOT}
	xscreensaver? ( x11-libs/libXScrnSaver )"

KMCOPYLIB="libkonq libkonq/"
KMEXTRACTONLY="kcheckpass/kcheckpass.h
	libkonq/
	kdm/kfrontend/themer/
	kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test
KMCOMPILEONLY="kcontrol/background
	kdmlib/"
KMNODOCS=true

src_unpack() {
	kde-meta_src_unpack
	# see bug #143375
	sed  -e "s:SUBDIRS = . lock pics patterns programs init:SUBDIRS = . lock pics patterns programs:" \
		-i kdesktop/Makefile.am
}

src_compile() {
	myconf="${myconf} $(use_with xscreensaver)"
	kde-meta_src_compile
}

pkg_postinst() {
	kde_pkg_postinst

	dodir "${PREFIX}"/share/templates/.source/emptydir
}
