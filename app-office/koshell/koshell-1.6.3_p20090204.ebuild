# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koshell/koshell-1.6.3_p20090204.ebuild,v 1.8 2009/09/27 12:33:41 ranger Exp $

ARTS_REQUIRED="never"

KMNAME=koffice
inherit kde-meta eutils

DESCRIPTION="KOffice workspace."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="3.5"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="~app-office/koffice-libs-1.6.3_p20090204"
RDEPEND="${DEPEND}"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

need-kde 3.5
