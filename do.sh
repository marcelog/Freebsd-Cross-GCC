#!/bin/bash
. ./config
export PATH=${PATH}:${targetdir}/bin
export CFLAGS="-I${targetdir}/include -L${targetdir}/lib"
export LD_LIBRARY_PATH=${targetdir}/lib

mkdir -p ${targetdir}/${target}
mkdir -p ${work}

function libtool() {
	echo Cleaning up libtool
	rm -rf ${work}/libtool-${libtool}
	echo Uncompressing libtool
	tar jxf ${dist}/libtool-${libtool}.tar.bz2 -C ${work}
	cd ${work}/libtool-${libtool} && ./configure --prefix=${targetdir} --with-gnu-ld --enable-static --enable-shared --host=${target} && gmake && gmake install && cd -
}

function mpc() {
	echo Cleaning up mpc
	rm -rf ${work}/mpc-${mpc}
	echo Uncompressing mpc
	tar jxf ${dist}/mpc-${mpc}.tar.bz2 -C ${work}
	cd ${work}/mpc-${mpc} && ./configure --prefix=${targetdir} --with-gnu-ld --with-gmp=${targetdir} --with-mpfr=${targetdir} --enable-static --enable-shared --host=${target} && gmake && gmake install && cd -
}

function mpfr() {
	echo Cleaning up mpfr
	rm -rf ${work}/mpfr-${mpfr}
	echo Uncompressing mpfr
	tar jxf ${dist}/mpfr-${mpfr}.tar.bz2 -C ${work}
	cd ${work}/mpfr-${mpfr} && ./configure --prefix=${targetdir} --with-gnu-ld --with-gmp=${targetdir} --enable-static --enable-shared --host=${target} && gmake && gmake install && cd -
}

function gmp() {
	echo Cleaning up gmp
	rm -rf ${work}/gmp-${gmp}
	echo Uncompressing gmp
	tar jxf ${dist}/gmp-${gmp}.tar.bz2 -C ${work}
	cd ${work}/gmp-${gmp} && ./configure --prefix=${targetdir} --enable-shared --enable-static --enable-mpbsd --enable-fft --enable-cxx --host=${target} && gmake && gmake install && cd -
}

function gcc() {
	echo Cleaning up gcc
	rm -rf ${work}/gcc-${gcc}
	echo Uncompressing gcc
	tar jxf ${dist}/gcc-${gcc}.tar.bz2 -C ${work}
	cwd=`pwd`
	cd ${work}/gcc-${gcc} && mkdir objdir && cd objdir && ../configure --without-headers --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --disable-nls --enable-libssp --enable-gold --enable-ld --target=${target} --prefix=${targetdir} --with-gmp=${targetdir} --with-mpc=${targetdir} --with-mpfr=${targetdir}  --disable-libgomp && gmake && gmake install && cd ${cwd}

}

function binutils() {
	echo Cleaning up binutils
	rm -rf ${work}/binutils-${binutils}
	echo Uncompressing binutils
	tar jxf ${dist}/binutils-${binutils}.tar.bz2 -C ${work}
	cd ${work}/binutils-${binutils} &&./configure --enable-libssp --enable-gold --enable-ld --target=${target} --prefix=${targetdir} && gmake && gmake install && cd -

}

function freebsd() {
	tar jxf ${dist}/x86_64-pc-freebsd7-includes.tar.bz2 -C ${targetdir}/${target}
	tar jxf ${dist}/x86_64-pc-freebsd7-libs.tar.bz2 -C ${targetdir}/${target}
}

function freebsd_from_scratch() {
	echo Cleaning up FreeBSD
	rm -rf ${work}/freebsd-${freebsd}
	mkdir -p ${work}/freebsd-${freebsd}
	echo Uncompressing FreeBSD source
	tar jxf ${dist}/freebsd-${freebsd}.tar.bz2 -C ${work}/freebsd-${freebsd}
	mkdir -p ${targetdir}/${target}/include
	cd ${work}/freebsd-${freebsd}/sys/include
	patch Makefile < ../../../../dist/freebsd-${freebsd}.include.patch
	PATH=${PATH}:/usr/sbin:/sbin pmake \
		MACHINE=${freebsdtarget} \
		MACHINE_ARCH=${freebsdtarget} \
		MK_GPIB=yes \
		MK_HESIOD=yes \
		MK_BLUETOOTH=yes \
		MK_NCP=yes \
		MK_BIND_LIBS=yes \
		MK_IPFILTER=yes \
		BINOWN=${USER} \
		BINGRP=${USER} \
		LIBOWN=${USER} \
		LIBGRP=${USER} \
		DESTDIR=${targetdir}/${target}/include \
		installincludes
	cd  -
}

binutils
freebsd
gmp
mpfr
mpc
gcc
libtool
