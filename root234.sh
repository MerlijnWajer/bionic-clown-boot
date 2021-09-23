##########################################################################
##
##  Motorola universal root script
##  Linux/OSX version
##
##  Copyright (C) 2012 Dan Rosenberg (@djrbliss)
##
##  Slightly modified by Merlijn Wajer <merlijn@wizzup.org> for
##  Maemo Leste D3 scripts
##
##########################################################################
##
## Instructions#
##
##  1. Put your device in debugging mode
##
##  2. Attach it via USB
##
##  3. Run this script in the same directory as the rest of the extracted
##     zipfile
##
##########################################################################

platform=`uname`
if [ $(uname -p) = 'powerpc' ]; then
        echo "[-] PowerPC is not supported."
        exit 1
fi

if [ "$platform" = 'Darwin' ]; then
        adb="./adb.osx"
        version="OS X"
        mode="'Charge Only' mode"
else
        adb="./adb.linux"
        version="Linux"
        mode="'PC mode'"
fi
chmod +x $adb

which adb > /dev/null 2>&1
if [ $? -eq 0 ]; then
        adb="adb"
fi

echo "[*]"
echo "[*] Motofail: Universal Motorola Gingerbread Root Exploit ($version version)"
echo "[*] by Dan Rosenberg (@djrbliss)"
echo "[*]"
echo "[*] Tested on Droid 3, Droid Bionic, Droid RAZR, and Droid 4"
echo "[*]"
echo "[*] Before continuing, ensure USB debugging is enabled and that your phone"
echo "[*] is connected via USB."
echo "[*]"
echo "[*] Press enter to root your phone..."
read -n 1 -s
echo "[*]"

echo "[*] Waiting for device..."
$adb wait-for-device

echo "[*] Device found."

echo "[*] Deploying payload..."
$adb push root234/motofail /data/local/motofail
$adb shell "chmod 755 /data/local/motofail"

echo "[*] Owning phone..."
$adb shell "/data/local/motofail exploit"

echo "[*] Rebooting device..."
$adb reboot

echo "[*] Waiting for phone to reboot."
$adb wait-for-device

echo "[*] Attemping persistence..."
$adb remount
$adb push root234/su /system/bin/su
$adb shell "chmod 6755 /system/bin/su"
$adb shell "ln -s /system/bin/su /system/xbin/su"
$adb push root234/busybox /system/xbin/busybox
$adb shell "chmod 755 /system/xbin/busybox"
$adb shell "/system/xbin/busybox --install /system/xbin"
$adb push root234/Superuser.apk /system/app/Superuser.apk

echo "[*] Cleaning up..."
$adb shell "/data/local/motofail clean"
$adb shell "rm /data/local/motofail"

echo "[*] Rebooting..."
$adb reboot
$adb wait-for-device

echo "[*] Exploit complete!"
echo "[*] Press any key to exit."
read -n 1 -s
$adb kill-server
