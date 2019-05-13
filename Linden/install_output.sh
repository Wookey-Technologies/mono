#!/bin/bash

set -e
SOURCE=$(cd $PWD/Output; pwd)
DEST=$SANSAR
if [[ $# -eq 1 ]]; then
  DEST=$(cd $1; pwd)
fi
EXTERNAL=$DEST/Code/External/Mono

if [ -d "$EXTERNAL" ]; then
    # copy files to external
    rsync -am --copy-unsafe-links $SOURCE/* $EXTERNAL

    # copy runtime files
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/4.5 $DEST/Runtime/Mono/lib/mono/ 
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/gac $DEST/Runtime/Mono/lib/mono/ 

    # copy runtime binaries
    rsync -am --exclude='*.ilk' $SOURCE/x64/Release/bin/mono-2.0-sgen.* $DEST/Runtime/
    rsync -am --exclude='*.ilk' $SOURCE/x64/Release/bin/mono* $EXTERNAL/Linux/Release/bin/
    rsync -am --exclude='*.ilk' $SOURCE/x64/Debug/bin/mono* $EXTERNAL/Linux/Debug/bin/
    rsync -am --exclude='*.ilk' $SOURCE/x64/Release/bin/mono-sgen.exe $SOURCE/Linux/Release/bin/mono-sgen $SOURCE/x64/Release/bin/mono-2.0-sgen.* $DEST/Runtime/Mono/bin/ 
else
    echo "usage:  $0 <path to sansar>"
    exit -1
fi

