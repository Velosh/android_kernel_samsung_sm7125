#!/bin/bash

# Check if have toolchain/llvm folder
if [ ! -d "$(pwd)/gcc/" ]; then
   git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 gcc -b android-9.0.0_r59 --depth 1 >> /dev/null 2> /dev/null
fi

if [ ! -d "$(pwd)/llvm-sdclang/" ]; then
   git clone https://github.com/proprietary-stuff/llvm-arm-toolchain-ship-10.0 llvm-sdclang --depth 1 >> /dev/null 2> /dev/null
fi

# Export KBUILD flags
export KBUILD_BUILD_USER="velosh"
export KBUILD_BUILD_HOST="velosh"

# Export ARCH/SUBARCH flags
export ARCH="arm64"
export SUBARCH="arm64"

# Export ANDROID VERSION
export PLATFORM_VERSION=11
export ANDROID_MAJOR_VERSION=r

# Export CCACHE
export CCACHE_EXEC="$(which ccache)"
export CCACHE="${CCACHE_EXEC}"
export CCACHE_COMPRESS="1"
export USE_CCACHE="1"
ccache -M 50G

# Export toolchain/clang/llvm flags
export CROSS_COMPILE="$(pwd)/gcc/bin/aarch64-linux-android-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CC="$(pwd)/llvm-sdclang/bin/clang"

# Export if/else outdir var
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/a72q" ]; then
      mkdir a72q
   fi
   if [ ! -d "$(pwd)/a52q" ]; then
      mkdir a52q
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/a72q" ]; then
      mkdir a72q
   fi
   if [ ! -d "$(pwd)/a52q" ]; then
      mkdir a52q
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O=a72q vendor/a72q_defconfig
   "${CCACHE}" make -j64 O=a72q
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O=a52q vendor/a52q_defconfig
   "${CCACHE}" make -j64 O=a52q
fi
