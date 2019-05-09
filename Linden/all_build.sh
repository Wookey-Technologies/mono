#!/bin/bash

set -e 

function usage {
	echo "usage: $0 <sansar_path> <;separated builds> [dirs to install]"
	exit 1
}

if [[ $# -lt 2 ]] ; then
	usage
fi

sansar_path=$1
EXTERNAL=$sansar_path/Code/External/Mono

if [[ ! -d "$EXTERNAL" ]]; then
    echo "couldn't find $EXTERNAL below $sansar_path"
	usage
fi

./wsl_windows_build.sh
./linux_build.sh ${@:2}
./install_output.sh $sansar_path
