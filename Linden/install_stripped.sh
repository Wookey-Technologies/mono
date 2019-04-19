#!/bin/bash

set -e 
STRIPPED=$(cd $PWD/../Stripped; pwd)
DEST=$(cd $1; pwd)
EXTERNAL=$DEST/Code/External/Mono


if [ -d "$EXTERNAL" ]; then
    rsync -am --copy-unsafe-links --delete $STRIPPED/* $EXTERNAL
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/4.5/* $DEST/Runtime/Mono/lib/mono/4.5 
    rsync -am --copy-unsafe-links --existing $EXTERNAL/Linux/Release/lib/mono/gac/* $DEST/Runtime/Mono/lib/mono/gac 
    rsync -am $STRIPPED/x64/Release/bin/mono-2.0-sgen.dll $DEST/Runtime
    rsync -am $STRIPPED/x64/Release/bin/mono-sgen.exe $DEST/Runtime/Mono/bin
    rsync -am $STRIPPED/Linux/Release/bin/mono-sgen $DEST/Runtime/Mono/bin
else
    echo "couldn't fine $EXTERNAL below $DEST"
fi

