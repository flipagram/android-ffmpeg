#!/bin/bash

# usage
usage() {
cat << EOF
usage: $0 options

OPTIONS:
   -c             	clean
   -b             	build
   -u 				update git submodules
   -p=[profile]   	the profile to use
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
	clean=$1
	build=$2
	profile=$3
	echo ""
	echo "# Building $profile, clean:$clean, build:$build"
	echo ""

	if [[ "$clean"=="1" ]];
	then
		cd x264 && make clean && cd ..
		check_exit $?

	fi


}

# get args
CLEAN=""
BUILD=""
UPDATE=""
PROFILES=""
while getopts "cbup:" opt; do
    case $opt in
        c)
            CLEAN=1
            ;;
        b)
            BUILD=1
            ;;
        p)
            PROFILES="$PROFILES$OPTARG "
            ;;
        u)
            UPDATE=1
            ;;
        ?)
            usage
            ;;
    esac
done

# check args
if [[ -z $CLEAN && -z $BUILD ]];
then
	echo "Error, must at least clean or compile"
	usage
elif [[ -z "$PROFILES" ]];
then
	echo "Error, must profile a profile"
	usage
fi

# log
echo ""
echo "# Build configuration:"
echo "#     CLEAN: $CLEAN"
echo "#     BUILD: $BUILD"
echo "#     UPDATE: $UPDATE"
echo "#     PROFILES: $PROFILES"

# update
if [[ ! -z "$UPDATE" ]];
then

	# clean first
	if [[ ! -z "$CLEAN" && -e "ffmpeg" ]];
	then
		rm -rf ffmpeg && mkdir ffmpeg
	else
		mkdir -p ffmpeg
	fi
	if [[ ! -z "$CLEAN" && -e "x264" ]];
	then
		rm -rf x264 && mkdir x264
	else
		mkdir -p x264
	fi
	if [[ ! -z "$CLEAN" ]];
	then
		git submodule deinit -f .
	fi

	# init
	git submodule init && \
		git submodule update
	check_exit $?
fi

# build
for p in "$PROFILES";
do build_for_profile $CLEAN $BUILD $p
done


