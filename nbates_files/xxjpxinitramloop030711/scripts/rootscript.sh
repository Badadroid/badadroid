#!/system/bin/sh

#script to enable root on moviNAND loopback build.
#copy this script into the bada storage root, renamed to "mkext2images.sh" and run recovery mode to execute.
#after running this, install "superuser" from the android market
#10-July-2011

#chmod the su binary
toolbox chmod 4755 /system/xbin/su

#thats all, reboot
toolbox reboot