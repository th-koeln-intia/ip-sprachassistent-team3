#!/bin/sh
if [ -z "$1" ]
then
echo "Keinen Friendlyname übergeben. Pflegen Sie die Lampe manuell im Nodered Interface ein!"
else
sed -i 's/0x00158d000520ac5e/'$1'/g' /home/pi/apollo/node-red/data/flows_4532881a94df.json
fi
rm lampupdate.sh

