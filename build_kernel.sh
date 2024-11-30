#!/bin/bash

export ARCH=arm64

if [ -z $CROSS_COMPILE ] || [ -z $PATH ]; then
	export CROSS_COMPILE="/home/rissu/Documents/toolchains/aarch64-linux-android/bin/aarch64-linux-android-"
	export PATH="/home/rissu/Documents/toolchains/clang-11/bin:$PATH"
fi

if [ -z $DEFCONFIG ]; then
	DEFAULT_DEFCONFIG="vendor/rsuntk_defconfig"
else
	DEFAULT_DEFCONFIG=$DEFCONFIG
fi

export CLANG_TRIPLE=aarch64-linux-gnu-
export KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"
export PROJECT_NAME=a23

# do not remove
source ./scripts/rsubuild.sh

# fmt <target> <jobs> <defconfig> <llvm> <llvm_ias> <extra_env>
build defconfig $(nproc --all) `echo $DEFAULT_DEFCONFIG` false false `echo $KERNEL_MAKE_ENV`
build kernel $(nproc --all) `echo $DEFAULT_DEFCONFIG` false false `echo $KERNEL_MAKE_ENV`