#!/bin/bash

echo installing kexec to kexecboot
adb push scripts/kexebootstart.sh /sdcard
adb push kexecboot /sdcard
adb root/push busybox /sdcard
adb shell "su -c 'mount -o remount,rw /system'"
adb shell "su -c 'cp -r /sdcard/kexecboot /system/etc/'"
adb shell "su -c 'cp /system/xbin/true /system/bin/pvrsrvinit'"
adb shell "su -c 'mv  /system/bin/logwrapper /system/bin/logwrapper-backup'"
adb shell "su -c 'cp /sdcard/kexebootstart.sh /system/bin/logwrapper'"
adb shell "su -c 'cp /sdcard/busybox /system/bin/busybox'"
adb shell "su -c 'chmod 777 /system/bin/logwrapper'"
adb shell "su -c 'chmod 777 /system/bin/busybox'"
adb reboot
