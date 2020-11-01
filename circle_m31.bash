#!/bin/bash

sudo apt install tar bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python

df -h
nproc
curl -O https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip
mkdir ~/bin/
curl https://storage.googleapis.com/git-repo-downloads/repo > /content/bin/repo
chmod a+x ~/bin/repo
git config --global user.email "dr.revanthstrakz@gmail.com"
git config --global user.name "Revanth Strakz"
git config --global color.ui false
PATH=pwd/platform-tools:$PATH
PATH=~/bin:$PATH
repo init --depth=1 -u https://github.com/LineageOS/android.git -b lineage-17.1
repo sync -c -j1000 --force-sync --no-clone-bundle --no-tags



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
    git -C kernel/samsung/universal9610 reset --hard origin/lineage-17.1
else
	git clone --depth=1 https://github.com/erfanoabdi/android_kernel_samsung_universal9610 -b lineage-17.1 kernel/samsung/universal9610
fi

git clone --depth=1 https://github.com/LineageOS/android_hardware_samsung -b lineage-17.1 hardware/samsung
git clone --depth=1 https://github.com/LineageOS/android_hardware_samsung_slsi_fm -b lineage-17.1 hardware/samsung_slsi/fm

df -h 
ls -al
( find . -type d -name ".git" && find . -name ".gitignore" && find . -name ".gitmodules" ) | xargs -d '\n' rm -rf
rm -rf .repo
rm -rf .git
rm -rf */.git
df -h
ls -al
echo '[+] Setup environment...'
. build/envsetup.sh



echo '[+] Lunching...'
lunch lineage_$DEVICE-userdebug

echo '[+] Make cleaning...'
make installclean -j1000

echo '[+] Making rom...'
make bacon -j100

