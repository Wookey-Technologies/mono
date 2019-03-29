#!/bin/bash


set -e

base=$(dirname "$PWD")
configure_options='--with-mcs-docs=no --with-overridable-allocators --with-large-heap=yes'
rm -rf $base/Output/Linux $base/Output/include
cd ..

export NOCONFIGURE=1
./autogen.sh

export CFLAGS="-DPIC_INITIAL_EXEC -w"
printf "Building Release\n===========================\n===========================\n===========================\n===========================\n"
./configure  --prefix=$base/Output/Linux/Release $configure_options
make || make
make install

make clean
printf "Building Debug\n===========================\n===========================\n===========================\n===========================\n"
export CFLAGS="-O0 -w -DPIC_INITIAL_EXEC"
./configure  --prefix=$base/Output/Linux/Debug $configure_options
make || make
make install

cd $base

./linux_install.sh

#build cecil
./build_cecil.sh || true
./build_json.sh

echo "You should now reconcile $base/Output"
