#!/bin/bash


set -e

base=$PWD

#remove old profiles
profiles=("2.0-api" "3.5-api" "4.0" "4.0-api"  "4.5.1-api"  "4.5.2-api"  "4.6.1-api"  "4.6.2-api"  "4.6-api"  "4.7.1-api"  "4.7-api")
configs=("Debug" "Release")
for config in "${configs[@]}" ; do 
    for profile in "${profiles[@]}" ; do
        rm -rf $base/Output/Linux/$config/lib/mono/$profile
    done
done

#copy headers
rsync -avm --include='*.h' --include='*.hw' -f 'hide,! */' $base/../ $base/Output/include --exclude='Linden'

# remove broken symlinks
find $base/Output/Linux/ -type l -xtype l -prune -exec rm {} +

cp $base/Output/Linux/Release/lib/mono/monodoc/monodoc.dll $base/Output/Linux/Release/lib/mono/4.5/
cp $base/Output/Linux/Debug/lib/mono/monodoc/monodoc.dll $base/Output/Linux/Debug/lib/mono/4.5/

#replace symlinks with the actual file (cuz windows and UAC difficulties with p4)
sed -i '' $base/Output/Linux/Release/lib/mono/4.5/**.* || true
sed -i '' $base/Output/Linux/Debug/lib/mono/4.5/**.* || true

cd $base
