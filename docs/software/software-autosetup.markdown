---
layout: default
title: Auto setup
nav_order: 2
parent: Software
---

<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Installation using our Installscript

This script implements everything covered in the [skill implementation](../skills/intro/skill-intro.html){:target="_blank"} section. Before running this script install your Pi according to the hardware [page](../hardware/hardware-setup.html){:target="_blank"}.

Do not run the script as root or with sudo!

```shell
wget https://raw.githubusercontent.com/th-koeln-intia/ip-sprachassistent-team3/master/config/auto_install/install.sh
chmod 777 install.sh
./install.sh
```

If you are asked to continue, enter ```y``` and hit ```enter```.

After the install script has completed you have to reboot your pi.

```shell
sudo reboot
```

Apollo can be started after the reboot by using the following commands.

```shell
cd ~/apollo
docker-compose up -d
```

This may take some time. After everything has been started you can access the Rhasspy's interface at ```pi's-ip:12101```. Node-RED can be accessed at ```pi's-ip:1880```.

ZigBee devices can be connected using the web interface available ```pi's-ip:1337```.
