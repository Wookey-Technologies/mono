#!/bin/bash

set -e
MONO_PATH=`cd $PWD/Output/Linux/Release/lib; pwd`
PATH=$MONO_PATH/../bin:$PATH
common_args=/p:Configuration=net_4_0_Release\;NoCompilerStandardLib=false\;OutDir=$MONO_PATH/mono/4.5/

$MONO_PATH/../bin/mono $MONO_PATH/mono/4.5/xbuild.exe /verbosity:n /nologo ../external/cecil/Mono.Cecil.csproj             $common_args
$MONO_PATH/../bin/mono $MONO_PATH/mono/4.5/xbuild.exe /verbosity:n /nologo ../external/cecil/rocks/Mono.Cecil.Rocks.csproj $common_args


rsync -am $MONO_PATH/mono/4.5/Mono.Cecil.* Output/Linux/Debug/lib/mono/4.5 
