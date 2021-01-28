---
layout: default
title: Setting up your Pi
nav_order: 1
parent: Setup
---

<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Setting up your Pi

## Installing of the Pi's OS

In order to install Raspbian OS, you will have to download the latest version of [Raspberry Pi Imager](https://www.raspberrypi.org/software/).

 After downloading Raspberry Pi Imager, select ``Raspberry Pi OS Lite`` as your Operating System, select your SD card and press write to start flashing your SD card.

 ![PI1](../assets/raspberry1.png)

 After flashing your SD card, you should see two partitions, one of which is named boot. Note that you might have to extract and reinsert the SD card in case the partition does not show up immediately. Create a file called ssh to enable ssh daemon on boot.

 ```shell
cd /media/<yourname>/boot/ # change directory to boot partition
touch ssh # create empty file called ssh
```

 If you wish to use WiFi instead of LAN, create a file called wpa_supplicant.conf inside the boot partition.

```shell
cd /media/<yourname>/boot/ # change directory to boot partition
nano wpa_supplicant.conf # open file in text editor nano
```

Paste the following into the file.

```shell
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="<Your WLAN name>"
    psk="<Your WLAN password>"
}
```

Note that you might need to change the country code accordingly.

Press CTRL + X and then Y and hit enter to save the file.

You should now see two new files, ssh and called wpfa_supplicant.conf, in your boot partition:

 ![PI4](../assets/raspberry4.png)

 Insert the SD card into your Pi and turn it on.
 Since we decided on a headless approach to using the Pi, you will need to access the Pi via SSH from this point on. For this, you will need to know the IP address of your Pi and a SSH client of some sort installed on your PC.

 ```shell
 ssh pi@<IP address of your Pi>
 ```

 Now that you have accessed your Pi, it is good practise to bring it up to date with the following commands.

 ```shell
 sudo apt update 
 sudo apt full-upgrade 
 ```

## Additional software

In order to clone repositories, which will be necessary often during development of our VA, you need to install Git onto your Pi.

```shell
sudo apt install git
```

## Installing the microphone driver

```shell
git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh
sudo reboot
```

This might take a while so do not be surprised.

After the Pi reboots, you need to edit the asound.conf. You access it via 

```shell
sudo nano /etc/asound.conf
```

Comment everything out starting from ``pcm.!default`` up to its last curly bracket by using #. Then, you add the following below it.

```shell
pcm.!default {
 type pulse
 # If defaults.namehint.showall is set to off in alsa.conf, then this is
 # necessary to make this pcm show up in the list returned by
 # snd_device_name_hint or aplay -L
 hint.description "Default Audio Device"
}
ctl.!default {
 type pulse
}
```

Lastly, you need to set the 3.5 mm jack as the default output. Do the following.

```shell
sudo raspi-config

Select Advanced Options
Select Audio
Select Force 3.5mm ('headphone') jack
Select Finish
```

## Installing the Docker Containers

All required services will be run using docker containers. For this, you will need to install Docker on your Pi.

```shell
curl -sSL https://get.docker.com | sh # install docker
sudo usermod -a -G docker $USER # user is part of docker group
sudo apt-get install docker-compose # install docker-compose
sudo reboot # reboot your Pi
```

We use docker-compose for faster installation and an easier configuration of our containers.

### Rhasspy Service

Installing the Rhasspy service inside a Docker container.

```shell
mkdir rhasspy # create folder for rhasspy service
cd rhasspy # change into rhasspy directory
nano docker-compose.yml # create the docker-compose configuration using nano
```

```conf
rhasspy: # service name
    image: "rhasspy/rhasspy" # use rhasspy docker image
    container_name: rhasspy # name of our container
    restart: unless-stopped # automatically restarts container if crashed
    volumes: # map volumes on your Pi as shared volume in the container
        - "$HOME/rhasspy/.config/rhasspy/profiles:/profiles"
        - "/etc/localtime:/etc/localtime:ro"
    ports: # open the required ports
        - "12101:12101" # webserver
        - "12183:12183" # MQTT server
    devices:
        - "/dev/snd:/dev/snd" # connect mic to docker container
    command: --user-profiles /profiles --profile de # start rhasspy with custom commands
```

Press CTRL + X and then Y and hit enter to save the file.

Now you can start your Rhasspy service.

```shell
docker-compose up -d # starts the container
```

### Rasa NLU service

The official Rasa image cannot be run on the Pi's ARM based CPU. Because of this, we use an [unofficial image](https://github.com/koenvervloesem/rasa-docker-arm) compatible with ARM.

```shell
cd /home/pi/ # switch to home directory
mkdir rasa # create a folder for rasa service
cd rasa # switch into the rasa folder
mkdir bin # create folder for rasa installation
cd bin # switch into the bin folder
docker run -it -v "$(pwd):/app" -p 5005:5005 koenvervloesem/rasa:latest init # run container once to initialize rasa
```

Rasa will now guide you through the initialization process. Rasa will ask you which directory to use. Confirm by pressing enter to use your current directory.

Afterwards, Rasa will ask you whether you want to train an initial model. This step is crucial since this model is needed for further training of your voice assistant.  

When Rasa asks you whether you want to talk to a chatbot, press CTRL + C to stop the container. Next, you have to create a docker-compose file, the contents of which you can find below:

```shell
cd .. # switch to higher directory
nano docker-compose.yml # create docker-compose file using nano
```

```shell
rasa:
    image: "koenvervloesem/rasa:latest" # name of the used unofficial image
    container_name: rasa
    restart: unless-stopped
    volumes:
        - "/home/pi/rasa/bin:/app"
        - "/home/pi/rhasspy/.config/rhasspy/profiles:/profiles"
    ports:
        - "5005:5005"
    command: run --enable-api --debug
```

```shell
docker-compose up -d # starts the container
```

If it tells you it is done with creating Rasa, you have been successful.

## Configuring Rhasspy

You can reach your Rhasspy site via [raspberrypi:12101](raspberrypi:12101) in your webbrowser. If using raspberrypi does not work, you can also use your Pi's IP address instead, like this:

 ``<IP of your Pi>:12101``

You need to change your Rhasspy's settings according to the picture below.

![rhasspy_settings](../assets/rhasspy_settings.png)

If you have the web interface open but happen to get an error message saying ``cannot connect to localhost:5005``, check the Intent Recognition settings by clicking on the according row. A dropdown should appear. Check the Server URL and replace localhost with your Pi's IP address.  

You can also use our profile.json below:

```shell
sudo nano /home/pi/rhasspy/.config/rhasspy/profiles/de/profile.json
```

Replace everything in the profile.json file with the following:

```shell
{
    "dialogue": {
        "system": "rhasspy"
    },
    "intent": {
        "rasa": {
            "config_yaml": "rasa_cfg.yaml",
            "url": "http://raspberrypi:5005/"
        },
        "system": "rasa"
    },
    "microphone": {
        "system": "pyaudio"
    },
    "sounds": {
        "system": "aplay"
    },
    "speech_to_text": {
        "system": "pocketsphinx"
    },
    "text_to_speech": {
        "system": "nanotts"
    },
    "wake": {
        "pocketsphinx": {
            "keyphrase": "Apollo",
            "threshold": 1e-14
        },
        "system": "pocketsphinx"
    }
}
```

Press CTRL + X and then Y and hit enter to save the file.

You also need a rasa config named rasa_cfg.yaml in our case

```shell
sudo nano /home/pi/rhasspy/.config/rhasspy/profiles/de/rasa_cfg.yaml
```

Paste the following inside your rasa_cfg.yaml file:

```shell
language: "de"
pipeline: "tensorflow_embedding"
```

Press CTRL + X and then Y and hit enter to save the file.

Go back to the web interface and press restart. Rhasspy will now load your profile.json file. Rhasspy might ask you to download certain dependencies, which you have to confirm.

Next, you have to add your custom hotword to the Pocketsphinx dictionary. Enter it into the textbox and press "Guess Word". The word and its phonetic pronunciation will be displayed by Rhasspy. Add the pronunciation to the dictionary by pressing "Save Custom Words".

![dictionary](../assets/Rhasspy2.png)

To check whether the custom hotword was successfully added, clearly say your custom hotword. The Pi should react to the hotword and give output inside the shell. It should look like this:

![output](../assets/output.png)
