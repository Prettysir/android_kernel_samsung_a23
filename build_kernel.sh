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

setconfig() { # fmt: setconfig enable/disable <CONFIG_NAME>
	if [ -d $(pwd)/scripts ]; then
		./scripts/config --file $KERNEL_OUT/.config --`echo $1` CONFIG_`echo $2`
	else
		pr_err "Folder scripts not found!"
	fi
}

if [ "$KSU" = "true" ]; then
	curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s main
fi

IMAGE="$(pwd)/out/arch/arm64/boot/Image"

# main build script, don't remove it
source ./scripts/rsubuild.sh

build defconfig `echo $JOBS` `echo $DEFCONFIG` false false `echo $KERNEL_MAKE_ENV`

if [ "$KSU" = "true" ]; then
	setconfig enable KSU
fi

build kernel `echo $JOBS` false false `echo $KERNEL_MAKE_ENV`

if [ -e $IMAGE ] && [ -d $(pwd)/AnyKernel3 ]; then
	if [ ! -z $DEVICE ]; then
		DEVICE_MODEL="`echo $DEVICE`-"
	fi
	cp $IMAGE AnyKernel3/ && cd AnyKernel3 && zip -r6 ../`echo $DEVICE_MODEL`AnyKernel3_`echo $DATE`.zip *
	if [[ $IS_CI != "true" ]]; then
		rm Image && cd ..
	fi
fi