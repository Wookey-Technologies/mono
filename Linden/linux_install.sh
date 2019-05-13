#!/bin/bash


set -e

base=$PWD

BUILD_CONFIGURATIONS="$1"

if [ -z "$BUILD_CONFIGURATIONS" ]; then
  echo "no build configurations specified"
	exit -1
fi

#remove old profiles
profiles=("2.0-api" "3.5-api" "4.0" "4.0-api"  "4.5.1-api"  "4.5.2-api"  "4.6.1-api"  "4.6.2-api"  "4.6-api"  "4.7.1-api"  "4.7-api")
configs=("Debug" "Release")
for config in "${configs[@]}" ; do 
  if [[ $BUILD_CONFIGURATIONS == *$config* ]]; then
    for profile in "${profiles[@]}" ; do
      rm -rf $base/Output/Linux/$config/lib/mono/$profile
    done
  fi
done

#copy headers
echo "Copying headers"
rsync --stats -am --include='*.h' --include='*.hw' -f 'hide,! */' $base/../mono $base/Output/include/
rsync -am $base/../*.h $base/Output/include

# remove broken symlinks
find $base/Output/Linux/ -type l -xtype l -prune -exec rm -v {} +

for config in "${configs[@]}" ; do
  if [[ $BUILD_CONFIGURATIONS == *$config* ]]; then
    cp $base/Output/Linux/$config/lib/mono/monodoc/monodoc.dll $base/Output/Linux/$config/lib/mono/4.5/ 2> /dev/null || true

    cp $base/Output/x64/$config/bin/* $base/Output/Linux/$config/bin 2> /dev/null || true

    find $base/Output/Linux/$config/lib/mono -type l -exec sed -i '' {} +
  fi
done

if [[ $BUILD_CONFIGURATIONS != *"Release"* ]]; then
  echo "copying Debug to Release"
  rsync --stats -am --ignore-existing $base/Output/Linux/Debug/* $base/Output/Linux/Release
fi
cd $base
