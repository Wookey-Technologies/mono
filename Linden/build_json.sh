#!/bin/bash

set -x
MONO_PATH=`cd $PWD/Output/Linux/Release/lib; pwd`
PATH=$MONO_PATH/../bin:$PATH
common_args=/p:Configuration=Debug\;NoCompilerStandardLib=false\;OutDir=$MONO_PATH/mono/4.5/

$MONO_PATH/../bin/mono $MONO_PATH/mono/4.5/xbuild.exe ../external/Newtonsoft.Json/Src/Newtonsoft.Json/Newtonsoft.Json.csproj $common_args
