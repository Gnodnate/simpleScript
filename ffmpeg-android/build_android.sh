#!/bin/sh

NDK=~/android-sdk-macosx/ndk-bundle # NDK path
platformVersion=android-21 # platform version

scriptPath=`dirname $0`
cd $scriptPath #change the work path into script file path

#prepare final folder
LIBS=$(pwd)/ffmpeg-android/libs

if [ ! -e ffmpeg ]; then
    git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
fi
cd ffmpeg/

for ARCH in arm aarch64 x86 x86_64; do
#for ARCH in aarch64; do
    hostPlatform=$(uname -s | tr "[:upper:]" "[:lower:]")
    TOOLCHAIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/$hostPlatform*/`

    ADDI_CFLAGS=""
    ADDITIONAL_CONFIGURE_FLAG=''
    
    case "$ARCH" in
        arm)
            CPU=armeabi
            SYSROOT=$NDK/platforms/$platformVersion/arch-arm/
            CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
            ADDI_CFLAGS="-marm"
            ;;
        aarch64)
            SYSROOT=$NDK/platforms/$platformVersion/arch-arm64/
            CPU=arm64-v8a
            CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
            ADDI_CFLAGS="-march=armv8-a"
            ;;
        x86)
            SYSROOT=$NDK/platforms/$platformVersion/arch-x86/
            CPU=x86
	         CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
            ADDITIONAL_CONFIGURE_FLAG=--disable-yasm
            ;;
        x86_64)
            SYSROOT=$NDK/platforms/$platformVersion/arch-x86_64/
            CPU=x86_64
            CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
            ADDITIONAL_CONFIGURE_FLAG=--disable-yasm
            ;;
    esac

    echo "================================================"
    echo "=================build for $CPU=============="
    echo "================================================"
    PREFIX=$(pwd)/build/$CPU
    mkdir -p $PREFIX
    ./configure \
        --prefix=$PREFIX \
        --enable-shared \
        --disable-static \
        --disable-doc \
        --disable-programs \
        --disable-avdevice \
        --disable-doc \
        --arch=$ARCH \
        --cross-prefix=$CROSS_PREFIX \
        --target-os=android \
        --enable-cross-compile \
        --sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
        $ADDITIONAL_CONFIGURE_FLAG

    if [ $? -eq 0 ]; then
        make clean
    	  cpuNum=4
    	  buildplatform=`uname -s`
  	     if [ $buildplatform = "Linux" ]; then
	         cupNum=`grep 'processor' /proc/cpuinfo |sort|uniq|wc -l`
	     fi
        make -j$cpuNum install > /dev/null
        if [ $? -eq 0 ]; then
            mkdir -p $LIBS/$CPU
            cp -r $PREFIX/include $LIBS/$CPU/
            mkdir -p $LIBS/$CPU
            cp -r $PREFIX/lib/* $LIBS/$CPU
	         # clean for next build
	         make clean
	     else
	         exit
        fi
        # remove compat o file, as they didn't clean by make clean
        rm -fr compat/*.o

    fi
done
