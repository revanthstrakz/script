#! /bin/bash
git clone --depth=1 https://github.com/revanthstrakz/azure-clang.git clang-llvm
TC_DIR=$(pwd)/clang-llvm
git clone --depth=1 https://github.com/revanthstrakz/SM-M315F-Kernel.git source
cd source
export KBUILD_BUILD_USER="Revanth"
export ARCH=arm64
export SUBARCH=arm64
export ANDROID_MAJOR_VERSION=q
KBUILD_COMPILER_STRING=$("$TC_DIR"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
PATH=$TC_DIR/bin/:$PATH
MAKE+=(
			CROSS_COMPILE=aarch64-linux-gnu- \
			CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
			CC=clang \
			AR=llvm-ar \
			OBJDUMP=llvm-objdump \
			STRIP=llvm-strip
		)
DEFCONFIG=exynos9610-m31nsxx_defconfig
make O=out $DEFCONFIG
make -j"$PROCS" O=out \
		NM=llvm-nm \
		OBJCOPY=llvm-objcopy \
		LD=ld.lld "${MAKE[@]}" 2>&1 | tee error.log
exit
exit

	
