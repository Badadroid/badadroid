# **Welcome to the Badadroid project page** #

# What is Badadroid Project? #
Badadroid is the project to port the Android Operating System to the Samsung Wave smartphones, for which Samsung just provides its propietary OS called Bada. Badadroid name comes from joining Bada + Android.

# Badadroid Project History #
Wave smartphones and Bada 1.0 OS were introduced by Samsung in 2010. S8500 (Wave I) and S8530 (Wave II) were the two first models, and they have, even by 2013's standards, good hardware, similar between them and similar to I9000 (Galaxy S). Samsung did not provide good support to Bada platform, Bada 2.0 release was delayed to 2012, and Bada OS and phones have finally been abandoned in 2013, with Samsung focusing in Tizen.

Badadroid project was started in 2011, with the idea to bring a functional android in these phones. Dual boot is possible through modified bootloaders, and as simple as a different key combo. The real porting implies coding kernel dealing with hardware; porting has evolved through several android and kernel versions (android 2.2 Froyo/linux kernel 2.6.32 was ported to S8500 in 2011, Android 4.0 ICS/linux kernel 3.0.1 was ported to S8500 in april 2012, `CyanogenMod` 10 based on Android 4.1 Jelly Bean/linux kernel 3.0.31 was ported in august 2012, giving also support to S8530 hardware, mainly different in display controller). In 2012 Rebellos managed to start modem communication, and in march 2013 the world's first working non-AT commands based RIL for non-Android phone has been released. Most of Badadroid RIL implementation was done by KB\_Jetdroid, Rebellos and Volk204, basing on opensource Replicant's RIL for Samsung Galaxy S.
More details about participating developers and development history [here](http://forum.xda-developers.com/showthread.php?t=1459391), by Rebellos.
In august 2013, Volk204 [continues](http://forum.xda-developers.com/showthread.php?p=44801842) Rebellos' work with `CyanogenMod` 10.1 Android 4.2.2, and in the same month [audio recording and video recording (microphone) is fixed](http://forum.xda-developers.com/showthread.php?p=44886529) by Volk204 and Rebellos.
In september 2013, [audio in calls is fixed](http://forum.xda-developers.com/showthread.php?p=45682082) by Volk204 and Tigrouzen.
In october 2013, [Mobile internet (data through modem) is fixed](http://forum.xda-developers.com/showpost.php?p=46684373&postcount=947) by Volk204 and Rebellos. In november 2013, [CM 10.2 Android 4.3](http://forum.xda-developers.com/showthread.php?t=2550138) upgrade is done by Volk204. In january 2014, [CM 11 Android 4.4.2](http://forum.xda-developers.com/showthread.php?t=2609560) upgrade is done by Volk204. In february 2014, [basic GPS support is added](http://forum.xda-developers.com/showthread.php?p=50548697). In may 2014, [Rebellos leaves the project](http://forum.xda-developers.com/showpost.php?p=52923129&postcount=12).


In 2014 there are several Badadroid ROMs with several changes, for example some of them oriented to game players.
Most ROMs use Rebellos kernel where all new functionality is implemented by him and other developers: Volk204 is the main developer of RIL funcionality. Rebellos provides a CM 10 ROM using his kernel: [ROM WIP CM10 "Jelly Bean"](http://forum.xda-developers.com/showthread.php?t=1851818), which is continued by Volk204 in [ROM WIP CM10.1](http://forum.xda-developers.com/showthread.php?t=2400126) , [ROM WIP CM10.2](http://forum.xda-developers.com/showthread.php?t=2550138) and [ROM WIP CM11](http://forum.xda-developers.com/showthread.php?t=2609560)


# Project Status: WIP Work In progress - Alpha #

The project is doing progress day by day, but because of lack of developers and the amount of work todo, it has still a long way ahead.
You can see a list of features of what is working and what is not in [ROM WIP CM11](http://forum.xda-developers.com/showthread.php?t=2609560) (previously in others threads, check Badadroid Project History), list which is sumarized here, associated with last ROM.

## WHAT DOES (SHOULD) WORK ##
  * Screen
  * Sound playback
  * Camera
  * Camera LED
  * Battery charge/gauge (**basic, see Warning in BUGS/TODO**)
  * SD card read/write
  * Recovery mode: CWM allows GAPPS install (android market allows app installation)
  * Connectivity
    * Wifi (including DHCP)
    * Bluetooth
  * Sensors:
    * Accelerometer
    * Magnetometer (Compass)
    * Proximity sensor
  * Vibrator
  * TV Out
  * Headphones
  * Microphone
  * Audio recording
  * Video recording
  * Radio Interface Layer/ Calls / SIM:
    * Basic radio functions: Netwok Registration, SIMcard communication, SMS, USSD, Call notifications
    * Audio in calls
    * Mobile data through modem (3G/2G)
    * DTMF Support
    * Network indicator
    * Search available networks and select networks
    * PIN and PUK entering
    * PIN enable/disable/change
    * MMS sending/receiving
    * Basic SIM\_IO implementation: reading Contacts, Messages, Voicemail number, SPN, ICCID from SIM card
    * Bluetooth headset in calls
  * GPS (**Basic, see TODO**)

Internal FM Radio works using [APP Sprint FM from Mike Reid](http://forum.xda-developers.com/showthread.php?t=1059296), with Settings> Audio> Method> Galaxy SL/i9003. It is an app unrelated with badadroid, and Wave phones are not in Supported Device List, so it has no support [see also this warning](http://forum.xda-developers.com/showpost.php?p=47614534&postcount=1667). This app has free version with some limitations (Sprint Free) and paid version (Spirit FM Unlocked)

## WHAT DOESN’T WORK (BUGS/TODO) ##
  * Network registration don't work with some SIM cards
  * Conference call
  * Some problems with audio codec settings, but generally it should work
  * Impossible to shut down phone in android, only restart
  * Battery charge: **Warning: Don't leave it charging without supervising - if it gets enormously hot, disconnect it - this can literally blow up battery as there is no overheating protection yet. Do not leave it connected on 100% - it'll discharge by 1% all the time, and then recharge, what's very unhealthy for battery**
  * Delete SMS on SIM [XDA post related with delete SMS on SIM implementation](http://forum.xda-developers.com/showpost.php?p=47892275&postcount=1731)
  * GPS [XDA post related "GPS is still WIP, but it is really working already"](http://forum.xda-developers.com/showthread.php?p=50548697)

# More information #

More info (repositories, updates, FAQ ,...) in [Badadroid wiki](Index.md) , in  [XDA developers Badadroid forum](http://forum.xda-developers.com/forumdisplay.php?f=1203) and specially [XDA developers NEWS & UPDATES Badadroid thread](http://forum.xda-developers.com/showthread.php?t=1459391)