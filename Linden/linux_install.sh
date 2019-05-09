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
echo "Copying headers"
rsync --stats -am --include='*.h' --include='*.hw' -f 'hide,! */' $base/../ $base/Output/include --exclude='Linden'

# remove broken symlinks
find $base/Output/Linux/ -type l -xtype l -prune -exec rm -v {} +

if   [[   -d "$base/Output/Linux/Release" && ! -d "$base/Output/Linux/Debug" ]]; then
	rsync -am $base/Output/Linux/Release/* $base/Output/Linux/Debug
elif [[ ! -d "$base/Output/Linux/Release" &&   -d "$base/Output/Linux/Debug" ]]; then
	rsync -am $base/Output/Linux/Debug/* $base/Output/Linux/Release
fi

for config in "${configs[@]}" ; do
  cp $base/Output/Linux/$config/lib/mono/monodoc/monodoc.dll $base/Output/Linux/$config/lib/mono/4.5/ 2> /dev/null || true

  cp $base/Output/x64/$config/bin/* $base/Output/Linux/$config/bin 2> /dev/null || true

  find $base/Output/Linux/$config/lib/mono -type l -exec sed -i '' {} +
done

cd $base
