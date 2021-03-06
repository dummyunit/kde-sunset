# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-kwin-styles/kdeartwork-kwin-styles-3.5.10.ebuild,v 1.8 2009/07/12 11:34:48 armin76 Exp $

EAPI="1"
KMMODULE=kwin-styles
KMNAME=kdeartwork
inherit kde-meta

DESCRIPTION="Window styles for kde"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="|| ( >=kde-base/kwin-${PV}:${SLOT} >=kde-base/kdebase-${PV}:${SLOT} )"
