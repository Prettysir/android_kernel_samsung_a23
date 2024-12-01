#! /usr/bin/env bash

# arg parser
if [ $# -lt 3 ]; then
	echo -e "Usage: `basename $0` <defconfig> <ksu:boolean> <job_count:int>"
	exit
else
	DEFCONFIG="$1"
	KSU="$2"
	JOBS="$3"
fi

export ARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-
export KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"
export PROJECT_NAME=a23

# main build script, don't remove it
source ./scripts/rsubuild.sh

build defconfig $(nproc --all) `echo $DEFCONFIG` false false `echo $KERNEL_MAKE_ENV`
build kernel $(nproc --all) `echo $DEFCONFIG` `echo $KERNEL_MAKE_ENV`
