#!/system/bin/sh

#script to create/recreate the ext2data.img and ext2cache.img files for Android on Wave.
#copy this script into the bada storage root and run it via recovery mode to create the data and cache images for Android to boot from moviNAND.
#05-July-2011

#Mount the partition where the image will be located, delete the image if it exists
echo mounting mmcblk0p3
busybox mount -w -t vfat /dev/block/mmcblk0p3 /mnt_ext/badablk3
echo removing old images
busybox rm /mnt_ext/badablk3/ext2data.img
busybox rm /mnt_ext/badablk3/ext2cache.img
echo done

#Create a data image file, configure it's loopback and create the filesystem
echo creating data image
busybox dd if=/dev/zero of=/mnt_ext/badablk3/ext2data.img bs=1024 count=600000
busybox losetup /dev/block/loop5 /mnt_ext/badablk3/ext2data.img
busybox mkfs.ext2 /dev/block/loop5 -L data
echo done

#Create a cache image file, configure it's loopback and create the filesystem
echo creating cache image
busybox dd if=/dev/zero of=/mnt_ext/badablk3/ext2cache.img bs=1024 count=100000
busybox losetup /dev/block/loop6 /mnt_ext/badablk3/ext2cache.img
busybox mkfs.ext2 /dev/block/loop6 -L cache
echo done

#de-associate the loop device, unmount the partition, then reboot
echo de-associating loopbacks, unmounting mmcblk0p3
busybox losetup -d /dev/block/loop5
busybox losetup -d /dev/block/loop6
busybox umount /mnt_ext/badablk3
busybox rm /mnt_ext/badablk2/mkext2images.sh
echo done, rebooting
toolbox reboot


