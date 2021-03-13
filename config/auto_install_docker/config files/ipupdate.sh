#!/bin/bash
ip=$(ip addr show wlan0 | grep -Po 'inet \K[\d.]+')
sed -i 's/192.168.0.177/'$ip'/g' /home/pi/apollo/node-red/data/flows_4532881a94df.json
rm ipupdate.sh
