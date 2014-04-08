#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

./configure \
$DEBUG_FLAG \
--arch=$FG_ARCH \
--cpu=$FG_ARCH \
--target-os=linux \
--enable-runtime-cpudetect \
--prefix=/home/brian/projects/flipagram/flipagram-android/flipagram-app-encoder/jni/external \
--enable-pic \
--disable-shared \
--enable-static \
--cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$NDK_ABI-linux-androideabi- \
--sysroot="$NDK_SYSROOT" \
--extra-cflags="-I../x264 -I$LOCAL/include -mfloat-abi=softfp -mfpu=$FG_FPU" \
--extra-ldflags="-L../x264 -L$LOCAL/lib" \
\
--enable-nonfree \
--enable-version3 \
--enable-gpl \
\
--enable-yasm \
\
--enable-decoders \
--enable-encoders \
--enable-muxers \
--enable-demuxers \
--enable-parsers \
--enable-protocols \
--enable-filters \
--enable-avresample \
\
--disable-indevs \
--enable-indev=lavfi \
--disable-outdevs \
\
--enable-hwaccels \
\
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-network \
\
--enable-libx264 \
--enable-zlib \
--enable-muxer=md5

popd; popd


