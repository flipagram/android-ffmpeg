#!/bin/bash

# usage
usage() {
cat << EOF
usage: $0 options

OPTIONS:
   -n [ndk base] 	base path to ndk
   -p [profile] 	the profile to use
EOF
exit 1
}

# checks to ensure an exit code is 0
check_exit() {
	if [[ "$1" != "0" ]];
	then
		echo ""
		echo "********************************"
		echo "* EXITING FOR ERROR CODE: $1"
		echo "********************************"
		echo ""
		exit $1
	fi
}

# builds for a particular profile
build_for_profile() {
	profile=$1
	ndk_base=$2
	echo ""
	echo "# Building $profile"
	echo ""

	# bring in settings
	. profiles/$profile.profile
	check_exit $?

	# setup ndk
	HOST_PROCESSOR=x86
	if [[ $(uname -m) == "x86_64" ]];
	then
	    HOST_PROCESSOR=x86_64
	fi
	# the rest
	PREFIX="$(pwd)/build/$profile"
	NDK_UNAME=`uname -s | tr '[A-Z]' '[a-z]'`
	NDK_TOOLCHAIN_BASE=$ndk_base/toolchains/$FG_NDK_TOOLCHAIN/prebuilt/$NDK_UNAME-$HOST_PROCESSOR
	NDK_SYSROOT=$ndk_base/platforms/android-$FG_NDK_API_LEVEL/arch-$FG_NDK_ARCH
	echo ""
	echo "***************** BUILD CONFIG"
	echo "* NDK_TOOLCHAIN_BASE: $NDK_TOOLCHAIN_BASE"
	echo "* NDK_SYSROOT: $NDK_SYSROOT"
	echo "***************** /BUILD CONFIG"
	echo ""

	# configure
	cd x264 && \
		echo ./configure --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$FG_NDK_CROSS_PREFIX \
			--extra-cflags=\"$FG_X264_EXTRA_CFLAGS\" \
			--prefix=$PREFIX \
			--sysroot=$NDK_SYSROOT \
			--host=$FG_X264_HOST \
			--enable-pic \
			--enable-static \
			--disable-asm \
			--disable-cli > wtf.sh && \
		echo "make install" >> wtf.sh && \
		sh wtf.sh && \
		cd ..
	check_exit $?

	# configure
	cd ffmpeg && \
		echo ./configure --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$FG_NDK_CROSS_PREFIX \
			--arch=$FG_NDK_ARCH \
			--cpu=$FG_FFMPEG_CPU \
			--target-os=linux \
			--enable-runtime-cpudetect \
			--prefix=$PREFIX \
			--enable-pic \
			--disable-shared \
			--enable-static \
			--sysroot=$NDK_SYSROOT \
			--extra-cflags=\"-I../x264 -I$PREFIX/include $FG_FFMPEG_EXTRA_CFLAGS\" \
			--extra-ldflags=\"-L../x264 -L$PREFIX/lib\" \
			--enable-nonfree \
			--enable-version3 \
			--enable-gpl \
			--enable-yasm \
			--enable-decoders \
			--enable-encoders \
			--enable-muxers \
			--enable-demuxers \
			--enable-parsers \
			--enable-protocols \
			--enable-filters \
			--enable-avresample \
			--disable-indevs \
			--enable-indev=lavfi \
			--disable-outdevs \
			--enable-hwaccels \
			--disable-ffmpeg \
			--disable-ffplay \
			--disable-ffprobe \
			--disable-ffserver \
			--disable-network \
			--enable-libx264 \
			--enable-zlib \
			--enable-muxer=md5 > wtf.sh && \
		echo "make install" >> wtf.sh && \
		sh wtf.sh && \
		cd ..
	check_exit $?

	# clean
	cd x264 && make clean && cd ..
	check_exit $?
	cd ffmpeg && make clean && cd ..
	check_exit $?

	# build

}

# get args
PROFILES=""
NDK_BASE=$ANDROID_NDK_HOME
while getopts "p:n:" opt; do
    case $opt in
        p)
            PROFILES="$PROFILES$OPTARG "
            ;;
        n)
            NDK_BASE="$OPTARG"
            ;;
        ?)
            usage
            ;;
    esac
done


# log
echo ""
echo "# Build configuration:"
echo "#     NDK_BASE:    $NDK_BASE"
echo "#     PROFILES:    $PROFILES"
echo ""

# clean first
if [[ -e build ]];
then
	rm -rf build
fi
mkdir build
rm -rf ffmpeg && mkdir ffmpeg && mkdir -p ffmpeg
check_exit $?
rm -rf x264 && mkdir x264 && mkdir -p x264
check_exit $?
git submodule deinit -f . && \
	git submodule init && \
	git submodule update
check_exit $?

# build
for p in "$PROFILES";
do build_for_profile $p $NDK_BASE
done


