#!/usr/bin/env bash

set -e

export BUILDROOT=`pwd`
set -x

#git clone https://github.com/nodejs/node.git
cd node
#git checkout v6.11.0
#/usr/bin/env CC="clang" CXX="clang++" ./configure --prefix=../node-v6.11.0-freebsd-x64
#make -j 4
make install
#strip -s  out/Release/node
cd ..
tar -cvf node-v6.11.0-freebsd-x64.tar node-v6.11.0-freebsd-x64
gzip node-v6.11.0-freebsd-x64.tar
