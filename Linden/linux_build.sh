#!/bin/bash


set -e

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
root="$( cd "$base/.." && pwd )"
configure_options='--with-mcs-docs=no --with-overridable-allocators --with-large-heap=yes'


if [[ ! -z "$1" ]]; then
	BUILD_CONFIGURATIONS="$1"
fi

if [ -z "$BUILD_CONFIGURATIONS" ]; then
	BUILD_CONFIGURATIONS="Release;Debug"
fi

DEBUG_PREFIX_FLAG=""
if [ -n "$DEBUG_PREFIX" ]; then
    DEBUG_PREFIX_FLAG="-fdebug-prefix-map=${root}=${DEBUG_PREFIX}"
fi

install_dirs=(".")

if [[ ! -z "${@:2}" ]]; then
	install_dirs=(${@:2})
else
	rm -rf $base/Output/Linux $base/Output/include
fi

cd $root

function build_config {

	local config=$1

	if [[ $BUILD_CONFIGURATIONS == *$config* ]]; then
		export CFLAGS="-DPIC_INITIAL_EXEC -w $DEBUG_PREFIX_FLAG"
		if [[ "Debug" == $config ]]; then 
			export CFLAGS="-O0 $CFLAGS"
		fi
		printf "Building $config with $CFLAGS\n===========================\n===========================\n===========================\n===========================\n"

		LAST_BUILD=$(cat $base/.last_build 2>/dev/null) || true

		if [ -z "$LAST_BUILD" ]; then		
			export NOCONFIGURE=1
			./autogen.sh
		fi

		if [[ "$LAST_BUILD" != "$config" ]]; then
			make clean || true 
			./configure  --prefix=$base/Output/Linux/$config $configure_options
			make
			echo $config > $base/.last_build
		fi 
		for install_dir in "${install_dirs[@]}" ; do 
			(cd $base/../$install_dir && make install)
		done
	fi

}

build_config Release
build_config Debug


cd $base

./linux_install.sh $BUILD_CONFIGURATIONS

#build cecil
./build_cecil.sh || true
./build_json.sh

