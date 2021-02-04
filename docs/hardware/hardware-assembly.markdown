---
layout: default
title: Assembly
nav_order: 2
parent: Hardware
---
<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Preparing your Raspberry Pi

## Installing an operating system 
[Raspberry Pi Imager](https://www.raspberrypi.org/software/){:target="_blank"} is our recommended option for flashing a operating system to a SD card.<br/>
After downloading Raspberry Pi Imager, select Raspberry Pi OS Lite as your operating system, select your SD card and press write to start flashing your SD card. Unplug and plug the SD card back into the card reader to continue. 

<img src="../img/imager.png" style="max-width: 75%;"/>

## Enabling Wifi and SSH 

### Wifi
If you wish to use WiFi instead of LAN, create a file called ```wpa_supplicant.conf``` inside the boot partition.

```shell
cd /media/<yourname>/boot/ # change directory to boot partition
sudo nano wpa_supplicant.conf # open file in text editor nano
```
Add the following to your file:
```shell
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="<your wlan name>"
    psk="<your wlan password>"
}
```
Press CTRL + x followed by y and then hit enter to save all changes.

### SSH
You can access the command line of a Raspberry Pi remotely from another computer or device on the same network using SSH. For headless setup, SSH can be enabled by placing a file named ```ssh```, without any extension, onto the boot partition of the SD card. 

## Assembling Hardware 

1. Insert SD card into your Raspberry Pi
2. Attach ReSpeaker 4-Mic Array
3. Plugin CC2531 ZigBee USB stick
4. Plugin a sound device using the 3.5mm jack 
5. Plugin power supply
6. Power your Raspberry Pi 

<img src="../img/pi.png" style="max-width: 75%;"/>

[Continue with software setup](../software/software.html)