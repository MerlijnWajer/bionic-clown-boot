#!/system/bin/sh

PATH=/sbin:/system/bin:/system/xbin
KEXEC_DIR=/system/etc/kexecboot
BBX=/system/bin/busybox

mount -o remount,rw rootfs
mount -o remount,rw /system
$BBX cp $KEXEC_DIR/* /
cd /
$BBX chmod 755 /kexec
$BBX chown 0.2000 /kexec
$BBX insmod /uart.ko
$BBX insmod /arm_kexec.ko
$BBX insmod /kexec.ko
$BBX cp $BBX /
/busybox umount -l /system
/kexec -l /zImageStatic --dtb=/omap4-droid3-xt862.dtb --command-line="console=ttyS2,115200 debug earlycon rootwait rootfstype=ext2 root=/dev/mmcblk1p14 ro init=/sbin/preinit.sh earlyprintk"
/busybox sleep 1
/kexec -e
