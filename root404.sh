#!/bin/bash

echo wait-for-device
adb wait-for-device
echo root stage 1
adb shell "rm -r /data/local/12m/batch 2>/dev/null"
adb shell "ln -s /data /data/local/12m/batch"
adb reboot
echo wait-for-device
adb wait-for-device
echo root stage 2
adb shell "rm /data/local.prop"
adb shell "echo 'ro.sys.atvc_allow_all_adb=1' > /data/local.prop"
adb reboot
echo wait-for-device
adb wait-for-device
echo root stage 3
adb remount
adb push root/su /system/bin/su
adb shell "chmod 6755 /system/bin/su"
adb shell "ln -s /system/bin/su /system/xbin/su 2>/dev/null"
adb push root/busybox /system/xbin/busybox
adb shell "chmod 755 /system/xbin/busybox"
adb shell "/system/xbin/busybox --install /system/xbin"
adb push root/Superuser.apk /system/app/Superuser.apk
adb shell "rm /data/local.prop"
adb shell "rm /data/local/12m/batch"
adb shell "chmod 771 /data"
adb shell "chown system.system /data"
adb reboot
echo wait-for-device
adb wait-for-device
echo root finished
