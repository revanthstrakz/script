#!/bin/bash

DEVICE=m31
ROOTDIR=~/android/lineage

export USE_CCACHE=1
export LANG=C

if [ -z $DEVICE ]; then
    echo DEVICE not set
    exit 1
fi

if [ -z $ROOTDIR ]; then
    echo ROOTDIR not set
    exit 1
fi


export LC_ALL=C

ccache -s

cd $ROOTDIR

echo '[+] Fetch vendor trees...'
if [ -d vendor/samsung ]; then
    git -C vendor/samsung fetch origin
    git -C vendor/samsung reset --hard origin/lineage-17.1
else
	git clone https://github.com/erfanoabdi/proprietary_vendor_samsung -b lineage-17.1 vendor/samsung
fi

#rm -rf device/samsung/m31
if [ -d device/samsung/m31 ]; then
    git -C device/samsung/m31 fetch origin
    git -C device/samsung/m31 reset --hard origin/lineage-17.1
else
	git clone https://github.com/erfanoabdi/android_device_samsung_m31 -b lineage-17.1 device/samsung/m31
fi

#rm -rf device/samsung/universal9610-common
if [ -d device/samsung/universal9610-common ]; then
    git -C device/samsung/universal9610-common fetch origin
    git -C device/samsung/universal9610-common reset --hard origin/lineage-17.1
else
	git clone https://github.com/erfanoabdi/android_device_samsung_universal9610-common -b lineage-17.1 device/samsung/universal9610-common
fi

#rm -rf kernel/samsung/universal9610
if [ -d kernel/samsung/universal9610 ]; then
    git -C kernel/samsung/universal9610 fetch origin
    git -C kernel/samsung/universal9610 reset --hard origin/lineage-17.1_older
else
	git clone https://github.com/erfanoabdi/android_kernel_samsung_universal9610 -b lineage-17.1_older kernel/samsung/universal9610
fi

echo '[+] Setup environment...'
. build/envsetup.sh


echo '[+] Lunching...'
lunch lineage_$DEVICE-userdebug

echo '[+] Make cleaning...'
make installclean -j8

echo '[+] Making rom...'
make bacon -j16

