# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-3.5.10.ebuild,v 1.6 2009/07/12 11:28:00 armin76 Exp $

EAPI="1"
KMNAME=kdesdk
KMMODULE=kioslave
inherit kde-meta eutils

DESCRIPTION="kioslaves from kdesdk package: the subversion kioslave"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE="kdehiddenvisibility"
DEPEND="dev-vcs/subversion"

pkg_setup() {
	if ldd /usr/bin/svn | grep -q libapr-0 \
		&& ! has_version dev-libs/apr:0;
	then
		eerror "Subversion has been built against dev-libs/apr:0, but no matching version is installed."
		die "Please rebuild dev-vcs/subversion."
	fi
	if ldd /usr/bin/svn | grep -q libapr-1 \
		&& ! has_version dev-libs/apr:1;
	then
		eerror "Subversion has been built against dev-libs/apr:1, but no matching version is installed."
		die "Please rebuild dev-vcs/subversion."
	fi
}

src_compile() {
	if ldd /usr/bin/svn | grep -q libapr-0; then
		myconf="--with-apr-config=/usr/bin/apr-config
		--with-apu-config=/usr/bin/apu-config"
	else
		myconf="--with-apr-config=/usr/bin/apr-1-config
		--with-apu-config=/usr/bin/apu-1-config"
	fi
	kde-meta_src_compile
}
