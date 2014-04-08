#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd x264

./configure --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/arm-linux-androideabi- \
	--arch=$FG_ARCH \
	--extra-cflags="-mfloat-abi=softfp -mfpu=$FG_FPU" \
	--prefix=$FG_DEST \
	--sysroot="$NDK_SYSROOT" \
	--host=arm-linux \
	--enable-pic \
	--enable-static \
	--disable-asm \
	--disable-cli

popd;popd
