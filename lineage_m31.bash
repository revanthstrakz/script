#!/bin/bash

DEVICE=m31

export USE_CCACHE=1
export LANG=C

export LC_ALL=C

ccache -s


echo '[+] Fetch vendor trees...'
if [ -d vendor/samsung ]; then
    git -C vendor/samsung fetch origin
    git -C vendor/samsung reset --hard origin/lineage-17.1
else
	git clone --depth=1 https://github.com/erfanoabdi/proprietary_vendor_samsung -b lineage-17.1 vendor/samsung
fi

#rm -rf device/samsung/m31
if [ -d device/samsung/m31 ]; then
    git -C device/samsung/m31 fetch origin
    git -C device/samsung/m31 reset --hard origin/lineage-17.1
else
	git clone --depth=1 https://github.com/erfanoabdi/android_device_samsung_m31 -b lineage-17.1 device/samsung/m31
fi

#rm -rf device/samsung/universal9610-common
if [ -d device/samsung/universal9610-common ]; then
    git -C device/samsung/universal9610-common fetch origin
    git -C device/samsung/universal9610-common reset --hard origin/lineage-17.1
else
	git clone --depth=1 https://github.com/erfanoabdi/android_device_samsung_universal9610-common -b lineage-17.1 device/samsung/universal9610-common
fi

#rm -rf kernel/samsung/universal9610
if [ -d kernel/samsung/universal9610 ]; then
    git -C kernel/samsung/universal9610 fetch origin
    git -C kernel/samsung/universal9610 reset --hard origin/lineage-17.1_older
else
	git clone --depth=1 https://github.com/erfanoabdi/android_kernel_samsung_universal9610 -b lineage-17.1_older kernel/samsung/universal9610
fi

git clone --depth=1 https://github.com/LineageOS/android_hardware_samsung -b lineage-17.1 hardware/samsung
git clone --depth=1 https://github.com/LineageOS/android_hardware_samsung_slsi_fm -b lineage-17.1 hardware/samsung_slsi/fm


echo '[+] Setup environment...'
. build/envsetup.sh

sudo dd if=/dev/zero of=/mnt/swapfile bs=1M count=18000
sudo mkswap /mnt/swapfile
sudo swapon /mnt/swapfile


echo '[+] Lunching...'
lunch lineage_$DEVICE-userdebug

echo '[+] Make cleaning...'
make installclean -j8

echo '[+] Making rom...'
make bacon -j16

cd $out
cd out
tar -cvzf upload.tar.gz *.img *.zip
curl https://bashupload.com/upload.tar.gz --data-binary @upload.tar.gz 
