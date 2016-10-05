#!/bin/sh

cd `dirname $0` #change the work path into script file path

#prepare final folder
LIBS=$(pwd)/android/libs
INCLUDE=$LIBS/include

NDK=~/android-sdk-macosx/ndk-bundle

function build_one
{
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
        #--sysroot=$SYSROOT \
#        --extra-cflags="-Os -fpic $ADDI_CFLAGS" 
    if [ $? == 0 ]; then
        make clean
        make -j4 install
        if [ S? == 0]; then
            mkdir -p $INCLUDE
            cp -r $PREFIX/include/* $INCLUDE/
            mkdir -p $LIBS/$CPU
            cp -r $PREFIX/lib/* $LIBS/$CPU
        fi
    fi
}

for cpu in arm64-v8a; do
    case "$cpu" in
        armeabi)
            CPU=armeabi
            ARCH=arm
            SYSROOT=$NDK/platforms/android-21/arch-arm/
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/arm-linux-androideabi-
            ADDI_CFLAGS="-marm"
        ;;
        arm64-v8a)
            SYSROOT=$NDK/platforms/android-21/arch-arm64/
            CPU=arm64-v8a
            ARCH=aarch64
            BIN=`echo $NDK/toolchains/$ARCH-*/prebuilt/*/bin/`
            CROSS_PREFIX=$BIN/aarch64-linux-android-
            ADDI_CFLAGS=""
        ;;
    esac
    build_one
done
