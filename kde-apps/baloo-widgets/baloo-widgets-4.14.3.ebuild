# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base kde4-functions-extra

DESCRIPTION="Widget library for baloo"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeframeworks_dep baloo)
	$(add_kdeframeworks_dep kfilemetadata)
"
RDEPEND="${DEPEND}"
