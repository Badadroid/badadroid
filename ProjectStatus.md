# Project Status: WIP Work In progress - Alpha #

The project is doing progress day by day, but because of lack of developers and the amount of work todo, it has still a long way ahead.
You can see a list of features of what is working and what is not in [ROM WIP CM11](http://forum.xda-developers.com/showthread.php?t=2609560) (previously in others threads, check Badadroid [Project History](ProjectHistory.md)), list which is sumarized here, associated with last ROM.


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