#!/bin/sh

cd `dirname $0` #change the work path into script file path

#prepare final folder
LIBS=$(pwd)/android/libs
#INCLUDE=$LIBS/include

NDK=~/sdk/android-sdk-linux/ndk-bundle

#for cpu in armeabi arm64-v8a x86 x86_64; do
for cpu in x86_64; do
    case "$cpu" in
        armeabi)
            CPU=armeabi
            ARCH=arm
            SYSROOT=$NDK/platforms/android-21/arch-arm/
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/arm-linux-androideabi-
        ;;
        arm64-v8a)
            SYSROOT=$NDK/platforms/android-21/arch-arm64/
            CPU=arm64-v8a
            ARCH=aarch64
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/aarch64-linux-android-
        ;;
        x86)
            SYSROOT=$NDK/platforms/android-21/arch-x86/
            CPU=x86
            ARCH=x86
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/i686-linux-android-
        ;;
        x86_64)
            SYSROOT=$NDK/platforms/android-21/arch-x86_64/
            CPU=x86_64
            ARCH=x86_64
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/x86_64-linux-android-
        ;;
    esac

    # clean last build, if any.
    make clean

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
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-ffserver \
        --disable-avdevice \
        --disable-doc \
        --disable-symver \
        --cross-prefix=$CROSS_PREFIX \
        --target-os=linux \
        --arch=$ARCH \
        --enable-cross-compile \
        --sysroot=$SYSROOT 
    if [ $? -eq 0 ]; then
        make clean
    	cpuNum=4
    	buildplatform=`uname -s`
  	if [ $buildplatform = "Linux" ]; then
		cupNum=`grep 'processor' /proc/cpuinfo |sort|uniq|wc -l`
	fi
        make -j$cpuNum install
        if [ $? -eq 0 ]; then
            mkdir -p $LIBS/$CPU
            cp -r $PREFIX/include $LIBS/$CPU/
            mkdir -p $LIBS/$CPU
            cp -r $PREFIX/lib/* $LIBS/$CPU
        fi
    fi
done
