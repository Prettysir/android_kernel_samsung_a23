#! /usr/bin/env bash

## Rissu Project ##
## Main kernel build script ##

if [ -z $CROSS_COMPILE ]; then
	echo -e "! CROSS_COMPILE undefined"
	exit
elif [ -z $PATH ]; then
	echo -e "! PATH undefined"
	exit
elif [ ! -z $PATH ]; then
	if ! command -v ld.lld; then
		echo -e "! ld.lld is not found! Do you set your path correctly?"
		exit
	fi
fi

build() {
	TARGET=$1
	JOBS=$2
	DEFCONFIG=$3
	LLVM=$4
	LLVM_IAS=$5
	
	if [ ! -z $6 ]; then
		EXTRA_ENV=$6
		MKFLAG="--jobs $JOBS -C $(pwd) O=$(pwd)/out KCFLAGS=-w $EXTRA_ENV"
	else	
		MKFLAG="--jobs $JOBS -C $(pwd) O=$(pwd)/out KCFLAGS=-w"
	fi
	
	if [ "$LLVM" = "true" ]; then
		MKFLAG+=" LLVM=1"
		export LLVM=1
		if [ "$LLVM_IAS" = "true" ]; then
			MKFLAG+=" LLVM_IAS=1"
			export LLVM_IAS=1
		fi
	fi
	
	echo -e "MKFLAG is [$MKFLAG]"
	if [ "$TARGET" = "kernel" ]; then
		make `echo $MKFLAG`
	elif [ "$TARGET" = "defconfig" ]; then
		make `echo $MKFLAG` `echo $DEFCONFIG`
	else
		echo -e "Target not defined/found: $TARGET"
		echo -e "fmt: build <target: kernel/defconfig> <total_job: int> <kernel_defconfig: string> <llvm:bool> <llvm_ias:bool> <extra_env:string>"
		exit
	fi
}