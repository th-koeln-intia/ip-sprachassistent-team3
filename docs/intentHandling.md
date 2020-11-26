---
layout: default
---

# XX

## Installing NodeRed


```shell
cd /home/pi/ # switch into Pi's directory
mkdir node-red # create directory called node-red
cd node-red # switch into that directory
mkdir data # create directory called data
nano docker-compose.yml # create docker-compose file using nano
```

```shell
nodered:
    image: "nodered/node-red"
    container_name: nodered
    restart: unless-stopped
    volumes:
        - "/home/pi/node-red/data:/data"
    ports:
        - "1880:1880"
```

Press CTRL + X and then Y and hit enter to save the file.

```shell
docker-compose up -d # starts the container
```

Now you can access the web interface [here](http://raspberrypi:1880).


```shell

```

## ZigBee2MQTT

```shell
cd /home/pi # switch into Pi's directory
mkdir zigbee2mqtt # create directory called zigbee2mqtt
cd zigbee2mqtt # switch into that directory
mkdir data # create directory called data
nano docker-compose.yml # create docker-compose file using nano
```

```shell
version: '3' # needed to use network_mode
  services:
    zigbee2mqtt:
      container_name: zigbee2mqtt
      image: koenkk/zigbee2mqtt
      volumes:
        - /home/pi/zigbee2mqtt/data:/app/data
        - /run/udev:/run/udev:ro
      devices:
        - /dev/ttyACM0:/dev/ttyACM0
      restart: always
      network_mode: host # connect directly to the Pi's network
      privileged: true
      environment:
        - TZ=Europe/Berlin # set the time zone
```

Press CTRL + X and then Y and hit enter to save the file.

```shell
docker-compose up -d # starts the container
```

