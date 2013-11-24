#!/bin/bash

function die {
  echo "$1 failed" && exit 1
}

./clean.sh

./configure_ogg.sh || die "ogg configure"
./make_ogg.sh || die "ogg make"

./configure_vorbis.sh || die "vorbis configure"
./make_vorbis.sh || die "vorbis make"

./configure_x264.sh || die "X264 configure"
./make_x264.sh || die "X264 make"

./configure_ffmpeg.sh || die "FFMPEG configure"
./make_ffmpeg.sh || die "FFMPEG make"


