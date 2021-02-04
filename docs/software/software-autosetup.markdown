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

Do not run the script as root or with sudo!

```shell
wget https://raw.githubusercontent.com/th-koeln-intia/ip-sprachassistent-team3/master/config/auto_install/install.sh
chmod 777 install.sh
./install.sh
```

If you are asked if you want to continue, enter y to confirm and press Agreeable_Nightcrawler

After the installscript has completed you have to reboot your pi once

```shell
sudo reboot
```

After the Pi has rebooted you can start Apollo with the following commands

```shell
cd ~/apollo
docker-compose up -d
```

This may take some time. After everything has been started you can access the rhasspy interface on the url <your-pi-ip>:12101 and node-red can be accessed on the url <your-pi-ip>:1880
