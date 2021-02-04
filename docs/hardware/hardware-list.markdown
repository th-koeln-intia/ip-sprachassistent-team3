---
layout: default
title: Shopping list
nav_order: 1
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

# Required hardware
Hardware required for following this guide:

## Raspberry Pi 
This project started on a Raspberry Pi 3 Model B+ with 1GB of Ram. Although functionality can be achieved using a Raspberry Pi 3, overheating and long processing times (crashes included) are no rarity. It is highly recommended to use a newer Model with at least 4GB of Ram. Most raspberry pies are shipped without a power supply. 

- [Raspberry Pi 3 Model B+ 1GB Ram](https://www.amazon.de/Raspberry-1373331-Pi-Modell-Mainboard/dp/B07BDR5PDW/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=raspberry+pi+3+b%2B%2C+4x+1%2C4+ghz%2C+1gb+ram&qid=1611774106&sr=8-3){:target="_blank"}
- [Raspberry Pi 4 Model B 4GB Ram](https://www.amazon.de/Raspberry-Pi-ARM-Cortex-A72-Bluetooth-Micro-HDMI/dp/B07TC2BK1X/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2R6VLO3B5KUIB&dchild=1&keywords=raspberry+pi+4&qid=1611774957&quartzVehicle=812-409&replacementKeywords=raspberry+pi&sprefix=raspberr%2Caps%2C185&sr=8-3){:target="_blank"} recommended
- [Raspberry Pi Power Supply](https://www.amazon.de/Raspberry-Pi-offizielles-Netzteil-Model/dp/B07TMPC9FG/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2OC2QH745IC7B&dchild=1&keywords=raspberry+pi+power+supply&qid=1611775136&sprefix=raspberry+pi+power%2Caps%2C172&sr=8-3){:target="_blank"}

## Micro SD card
Raspberry Pi devices use a micro SD card as storage device. 16Gb is enough for implementing all features shown in this guide. It is highly recommended to provided at least 32GB if you are planning on adding more functionality to your voice assistant.
- [16GB micro SD card](https://www.amazon.de/SanDisk-Ultra-microSDHC-Speicherkarte-Adapter/dp/B073K14CVB/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=MicroSDHC-Speicherkarte+16GB&qid=1611775897&sr=8-3){:target="_blank"}
- [32GB micro SD card](https://www.amazon.de/SanDisk-microSDHC-Speicherkarte-SD-Adapter-App-Leistung/dp/B08GY9NYRM/ref=sr_1_6?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=MicroSDHC-Speicherkarte+32GB&qid=1611775990&sr=8-6){:target="_blank"} recommended

## CC2531 ZigBee USB stick
This device handles communication between your voice assistant and your smart devices.

<b style="color:red">Attention</b>: firmware is required on this device to be used.
It is highly recommended to buy a CC2531 device with preinstalled firmware. 
- [CC2531 USB Stick with firmware](https://www.amazon.de/gp/product/B07V9K3GHH/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1){:target="_blank"} 

## ReSpeaker 4-Mic Array
Although it is possible to use any microphone u want for voice command transmission, it is highly suggested to use a [ReSpeaker 4-Mic Array](https://respeaker.io/4_mic_array/){:target="_blank"}. This microphone was designed to be used with voice enabled applications. 
- [ReSpeaker 4-Mic Array](https://www.amazon.de/MakerHawk-ReSpeaker-Raspberry-Quad-Microphone-Expansion-Applications/dp/B07FP78ZGX/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=29KT1U5Q49048&dchild=1&keywords=respeaker+4+mic+array&qid=1611778404&s=computers&sprefix=res%2Ccomputers%2C191&sr=1-3){:target="_blank"}

## Audio device
Rhasspy provides audio feedback using the default audio device connected to your raspberry pi. 
- [Logitech Z120 3.5mm speaker](https://www.amazon.de/Logitech-Notebook-Lautsprecher-USB-Stromversorgung-schwarz-silver/dp/B00544XKK4/ref=sr_1_1?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=LOGITECH+Z120&qid=1611780243&sr=8-1){:target="_blank"}

## Light bulb
Light control is one of the features covered in this guide. Smart device control is possible as long as your device supports ZigBee.
A list of supported devices can be found [here](https://www.zigbee2mqtt.io/information/supported_devices.html){:target="_blank"}.
- [Aqara LED Light Bulb](https://www.amazon.de/Aqara-ZNLDP12LM-LED-Light-Bulb/dp/B07X2TH2QL/ref=sr_1_1?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=aqara+znldp12lm&qid=1611778998&sr=8-1){:target="_blank"}

[Continue with hardware assembly](hardware-assembly.html)
