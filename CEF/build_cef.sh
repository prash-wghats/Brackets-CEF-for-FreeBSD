#!/usr/local/bin/bash

set -e

export BUILDROOT=`pwd`
set -x

sudo pkg install gtkglext
#Building LIBCEF 2704, 51.0.2704.103...
echo "Building LIBCEF 2704, 51.0.2704.103..."
svnlite co -r417184 svn://svn.freebsd.org/ports/head/www/chromium chromium
cd chromium
patch -p1 --ignore-whitespace < ../chromium_make.diff
rm files/patch-third__party_WebKit_Source_platform_text_CharacterPropertyDataGenerator.cpp
make configure
cd ..
mkdir libcef
cd libcef
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
#export PATH=$PATH:`pwd`/depot_tools
DEPOT_PATH=`pwd`/depot_tools
mv ../chromium/work/chromium-51.0.2704.103/ src
cd src
cp third_party/re2/re2.gyp.orig third_party/re2/re2.gyp
patch -p1 --ignore-whitespace < ../../libcef_cc.diff
git clone https://bitbucket.org/chromiumembedded/cef.git
cd cef
git checkout origin/2704
patch -p1 --ignore-whitespace < ../../../cef.diff
rm ../chrome/browser/renderer_preferences_util.cc.orig
rm ../content/browser/renderer_host/render_widget_host_view_aura.cc.orig
rm ../build/common.gypi.orig
env PATH=$PATH":"$DEPOT_PATH /usr/bin/env CC="cc" CXX="c++" GYP_GENERATORS=ninja GYP_DEFINES="clang_use_chrome_plugins=0  linux_dump_symbols=0 linux_breakpad=0  linux_use_heapchecker=0  linux_strip_binary=1  use_aura=1  test_isolation_mode=noop  disable_nacl=1  enable_extensions=1  enable_one_click_signin=1  enable_openmax=1  enable_webrtc=1  werror=  no_gc_sections=1  OS=freebsd  os_ver=1101001  prefix_dir=/usr/local  python_ver=2.7  use_allocator=none  use_cups=1  linux_link_gsettings=1  linux_link_libpci=1  linux_link_libspeechd=1  libspeechd_h_prefix=speech-dispatcher/  usb_ids_path=/usr/local/share/usbids/usb.ids  want_separate_host_toolset=0  use_system_bzip2=1  use_system_flac=1  use_system_harfbuzz=1  use_system_icu=0  use_system_jsoncpp=1  use_system_libevent=1  use_system_libexif=1  use_system_libjpeg=1  use_system_libpng=1  use_system_libusb=1  use_system_libwebp=0  use_system_libxml=1  use_system_libxslt=1  use_system_nspr=1  use_system_protobuf=0  use_system_re2=0  use_system_snappy=1  use_system_speex=1  use_system_xdg_utils=1  use_system_yasm=1 use_sysroot=0 v8_use_external_startup_data=1 use-lld=true flapper_version_h_file='/usr/home/prash/devel/electron/bracket/chromium/work/chromium-52.0.2743.116/flapper_version.h'  ffmpeg_branding=Chrome proprietary_codecs=1 use_gconf=1 use_pulseaudio=0 disable_sse2=1 clang=1" ac_cv_path_PERL=/usr/local/bin/perl ac_cv_path_PERL_PATH=/usr/local/bin/perl PERL_USE_UNSAFE_INC=1 PKG_CONFIG=pkgconf PYTHON="/usr/local/bin/python2.7" AR=/usr/bin/ar CFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option -fstack-protector -fno-strict-aliasing" CPPFLAGS="" CXXFLAGS="-O2 -pipe -isystem/usr/local/include -I/usr/local/include/atk-1.0 -Wno-unknown-warning-option  -fstack-protector -fno-strict-aliasing" LDFLAGS=" -L/usr/local/lib -fstack-protector" SHELL=/bin/sh CONFIG_SHELL=/bin/sh ./cef_create_projects.sh
cd ..
ninja -C out/Release cefclient
ninja -C out/Release cefsimple
ninja -C out/Release cef_unittests
cp third_party/icu/common/icudtl.dat out/Release/.
cd cef
cp -R tools/distrib/linux tools/distrib/freebsd
cd tools
./make_distrib.sh --ninja-build --x64-build
#BUILDROOT/libcef/src/cef/binary_distrib/*
cd $BUILDROOT
cp libcef/src/cef/binary_distrib/*.zip .

