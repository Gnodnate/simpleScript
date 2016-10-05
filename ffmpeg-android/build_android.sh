#!/bin/sh

NDK=~/sdk/android-sdk-linux/ndk-bundle # NDK path
platformVersion=android-21 # platform version

scriptPath=`dirname $0`
cd $scriptPath #change the work path into script file path

#prepare final folder
LIBS=$(pwd)/android/libs

cd ffmpeg/

#for cpu in armeabi arm64-v8a x86 x86_64; do
for cpu in armeabi; do
    ADDI_CFLAGS=""  # only need for arm
    case "$cpu" in
        armeabi)
            CPU=armeabi
            ARCH=arm
            SYSROOT=$NDK/platforms/$platformVersion/arch-arm/
	    BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/arm-linux-androideabi-
	    ADDI_CFLAGS="-marm"
            ;;
        arm64-v8a)
            SYSROOT=$NDK/platforms/$platformVersion/arch-arm64/
            CPU=arm64-v8a
            ARCH=aarch64
	    BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/aarch64-linux-android-
            ;;
        x86)
            SYSROOT=$NDK/platforms/$platformVersion/arch-x86/
            CPU=x86
            ARCH=x86
	    BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/i686-linux-android-
            ;;
        x86_64)
            SYSROOT=$NDK/platforms/$platformVersion/arch-x86_64/
            CPU=x86_64
            ARCH=x86_64
	    BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/x86_64-linux-android-
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
        --disable-symver \
        --cross-prefix=$CROSS_PREFIX \
        --target-os=linux \
        --arch=$ARCH \
        --enable-cross-compile \
	--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
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
	    # clean for next build
	    make clean
	else
	    exit
        fi
    fi
done
