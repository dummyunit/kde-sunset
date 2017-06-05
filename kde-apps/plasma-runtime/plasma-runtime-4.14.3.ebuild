# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KMNAME="kde-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
inherit kde4-meta kde4-functions-extra

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeframeworks_dep kactivities '' 4.13)
	$(add_kdeframeworks_dep kdelibs 'crypt')
"
RDEPEND="${DEPEND}"

RESTRICT=test
# bug 443748
