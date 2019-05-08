#!/bin/bash

set -e 
SOURCE=$(cd $PWD/Output; pwd)
DEST=$(cd $1; pwd)
EXTERNAL=$DEST/Code/External/Mono

if [[ $# -eq 0 ]] ; then
    echo "usage:  $0 <path to sansar>"
    exit -1
fi


if [ -d "$EXTERNAL" ]; then
    # copy files to external
    rsync -am --copy-unsafe-links $SOURCE/* $EXTERNAL

    # copy runtime files
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/4.5/* $DEST/Runtime/Mono/lib/mono/4.5 
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/gac/* $DEST/Runtime/Mono/lib/mono/gac 

    # copy runtime binaries
    rsync -am $SOURCE/x64/Release/bin/mono-2.0-sgen.* $DEST/Runtime
    rsync -am $SOURCE/x64/Release/bin/mono-sgen.exe $DEST/Runtime/Mono/bin
    rsync -am $SOURCE/Linux/Release/bin/mono-sgen* $DEST/Runtime/Mono/bin
else
    echo "couldn't find $EXTERNAL below $DEST"
fi

