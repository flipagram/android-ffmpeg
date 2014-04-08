#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd ffmpeg
make -j4
make prefix=$FG_DEST install
popd; popd
