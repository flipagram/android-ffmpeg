#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd vorbis

./autogen.sh \
	--disable-oggtest \
        CFLAGS="-I$LOCAL/include" \
        LDFLAGS="-L$LOCAL/lib" \
        CXX="$CXX" \
        CC="$CC" \
        LD="$LD" \
        STRIP="$STRIP" \
        --host=$HOST \
        --with-sysroot="$NDK_SYSROOT" \
        --enable-static \
        --disable-shared

./configure \
        CFLAGS="-I$LOCAL/include" \
        LDFLAGS="-L$LOCAL/lib" \
        CXX="$CXX" \
        CC="$CC" \
        LD="$LD" \
        STRIP="$STRIP" \
        --host=$HOST \
        --with-sysroot="$NDK_SYSROOT" \
        --enable-static \
        --disable-shared


popd; popd


