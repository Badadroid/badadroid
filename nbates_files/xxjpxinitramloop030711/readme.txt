This config is built to allow config of the data and cache partition images to be done via the script mkext2images.sh.
the images get stored on bada partition mmcblk0p3, system loopback gets mounted from mmcblk0p2

1:copy files sbl.bin and your zImage to galaxyboot as normal, as well as the ext2system.img
2:put mkext2images.sh into bada storage root
3:boot Android-Linux kernel in recovery mode and wait until the phone reboots
4:boot Android
