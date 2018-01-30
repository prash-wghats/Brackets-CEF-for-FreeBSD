#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x

sudo pkg install phantomjs

git clone https://github.com/adobe/brackets.git
cd brackets
git checkout release-1.11
git submodule update --init
npm install
rm node_modules/phantomjs/lib/phantom/bin/phantomjs
ln -s /usr/local/bin/phantomjs node_modules/phantomjs/lib/phantom/bin/phantomjs
patch -p1 --ignore-whitespace < ../phantomjs.diff 
grunt build
cd ..

git clone https://github.com/adobe/brackets-shell.git
cd brackets-shell
git checkout release-1.11
patch -p1  < ../brackets.diff
if [ -f ../../CEF/cef_binary_3.2704.1434.gec3e9ed_freebsd64.zip ]
then
	if [ ! -d downloads ]
	then
		mkdir downloads 
	fi
	cp ../../CEF/cef_binary_3.2704.1434.gec3e9ed_freebsd64.zip  downloads/.
fi
if [ -f ../node-v6.11.0-freebsd-x64.tar.gz ]
then
	cp ../node-v6.11.0-freebsd-x64.tar.gz  downloads/.
fi
npm install
grunt --force
grunt linux-stage
grunt package


