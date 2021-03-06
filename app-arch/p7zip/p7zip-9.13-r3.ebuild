# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/p7zip/p7zip-9.13-r3.ebuild,v 1.1 2010/11/14 12:10:32 jlec Exp $

EAPI="2"
WX_GTK_VER="2.8"

inherit eutils toolchain-funcs multilib wxwidgets

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src_all.tar.bz2"

LICENSE="LGPL-2.1 rar? ( unRAR )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc kde rar +pch static wxwidgets"

RDEPEND="kde? ( x11-libs/wxGTK:2.8[X,-odbc] kde-apps/konqueror )
	wxwidgets? ( x11-libs/wxGTK:2.8[X,-odbc] )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}_${PV}

pkg_setup() {
	use wxwidgets && wxwidgets_pkg_setup
}

src_prepare() {

	if use kde && ! use wxwidgets ; then
		einfo "USE-flag kde needs wxwidgets flag"
		einfo "silently enabling wxwidgets flag"
	fi

	if ! use pch; then
		sed "s:PRE_COMPILED_HEADER=StdAfx.h.gch:PRE_COMPILED_HEADER=:g" -i makefile.* || die
	fi

	# Being able to use native multilib
	sed \
		-e 's:-m32 ::g' \
		-e 's:-m64 ::g' \
		-i makefile* || die

	sed \
		-e "/^CC/s:\$(ALLFLAGS):${CFLAGS} \$(ALLFLAGS):g" \
		-e "/^CXX/s:\$(ALLFLAGS):${CXXFLAGS} \$(ALLFLAGS):g" \
		-i makefile* || die
	if use kde && ! use wxwidgets ; then
		einfo "USE-flag kde needs wxwidgets flag"
		einfo "silently enabling wxwidgets flag"
	fi

	# remove non-free RAR codec
	if use rar; then
		ewarn "Enabling nonfree RAR decompressor"
	else
		sed -e '/Rar/d' -i makefile*
		rm -rf CPP/7zip/Compress/Rar
		epatch "${FILESDIR}"/9.04-makefile.patch
	fi

	sed -i \
		-e "/^CXX=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e '/ALLFLAGS/s:-s ::' \
		makefile* || die "changing makefiles"

	if use amd64; then
		cp -f makefile.linux_amd64 makefile.machine
	elif [[ ${CHOST} == *-darwin* ]] ; then
		# Mac OS X needs this special makefile, because it has a non-GNU linker
		[[ ${CHOST} == *64-* ]] \
			&& cp -f makefile.macosx_64bits makefile.machine \
			|| cp -f makefile.macosx_32bits makefile.machine
		# bundles have extension .bundle but don't die because USE=-rar
		# removes the Rar directory
		sed -i -e '/strcpy(name/s/\.so/.bundle/' \
			CPP/Windows/DLL.cpp || die
		sed -i -e '/^PROG=/s/\.so/.bundle/' \
			CPP/7zip/Bundles/Format7zFree/makefile \
			$(use rar && echo CPP/7zip/Compress/Rar/makefile) || die
	elif use x86-fbsd; then
		# FreeBSD needs this special makefile, because it hasn't -ldl
		sed -e 's/-lc_r/-pthread/' makefile.freebsd > makefile.machine
	fi
	use static && sed -i -e '/^LOCAL_LIBS=/s/LOCAL_LIBS=/&-static /' makefile.machine

	# We can be more parallel
	cp -f makefile.parallel_jobs makefile

	#epatch "${FILESDIR}"/9.04-kde4.patch

	if use kde || use wxwidgets; then
		epatch "${FILESDIR}"/kde3-konq-system.patch
		einfo "Preparing dependency list"
		emake depend || die
	fi
}

src_compile() {
	emake all3 || die "compilation error"
	if use kde || use wxwidgets; then
		emake 7zG || die "error building GUI"
	fi
}

src_test() {
	emake test_7z test_7zr || die "test failed"
}

src_install() {
	# this wrappers can not be symlinks, p7zip should be called with full path
	make_wrapper 7zr "/usr/$(get_libdir)/${PN}/7zr"
	make_wrapper 7za "/usr/$(get_libdir)/${PN}/7za"
	make_wrapper 7z "/usr/$(get_libdir)/${PN}/7z"

	if use kde || use wxwidgets; then
		make_wrapper 7zG "/usr/$(get_libdir)/${PN}/7zG"

		dobin GUI/p7zipForFilemanager
		exeinto /usr/$(get_libdir)/${PN}
		doexe bin/7zG

		insinto /usr/$(get_libdir)/${PN}
		doins -r GUI/{Lang,help}

		if use kde; then
			insinto /usr/share/icons/hicolor/16x16/apps/
			newins GUI/p7zip_16_ok.png p7zip.png

			insinto /usr/kde/3.5/share/apps/konqueror/servicemenus/
			doins GUI/kde/*.desktop
		fi
	fi

	dobin contrib/gzip-like_CLI_wrapper_for_7z/p7zip || die
	doman contrib/gzip-like_CLI_wrapper_for_7z/man1/p7zip.1 || die

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/7z bin/7za bin/7zr bin/7zCon.sfx || die "doexe bins"
	doexe bin/*$(get_modname) || die "doexe *$(get_modname) files"
	if use rar; then
		exeinto /usr/$(get_libdir)/${PN}/Codecs/
		doexe bin/Codecs/*$(get_modname) || die "doexe Codecs/*$(get_modname) files"
	fi

	doman man1/7z.1 man1/7za.1 man1/7zr.1 || die
	dodoc ChangeLog README TODO || die

	if use doc ; then
		dodoc DOCS/*.txt
		dohtml -r DOCS/MANUAL/*
	fi
}
