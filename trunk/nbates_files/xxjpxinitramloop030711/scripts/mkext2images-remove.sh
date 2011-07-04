#!/system/bin/sh

#script to remove the ext2data.img and ext2cache.img files.
#copy this script into the bada storage root and run it via recovery mode to remove the android image files from your phone.
#05-July-2011

#Mount the partition where the image will be located, delete the image if it exists
echo mounting mmcblk0p3
busybox mount -w -t vfat /dev/block/mmcblk0p3 /mnt_ext/badablk3
echo removing old images
busybox rm /mnt_ext/badablk3/ext2data.img
busybox rm /mnt_ext/badablk3/ext2cache.img
echo done

#unmount the partition, then reboot
echo unmounting mmcblk0p3
busybox umount /mnt_ext/badablk3
busybox rm /mnt_ext/badablk2/mkext2images.sh
echo done, rebooting
toolbox reboot


