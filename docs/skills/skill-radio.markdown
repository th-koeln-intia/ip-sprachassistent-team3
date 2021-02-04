---
layout: default
parent: Skills
title: Radio
nav_order: 8
has_toc: true
---
<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Radio

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to create a radio station. A running mpd (music player daemon) server is required.

1. Provide radio output
2. Skip between radio stations
3. Radio out can be paused and resumed

### Radio station implementation

#### Music player daemon installation

```shell
cd ~
mkdir radio
cd radio
sudo apt-get -y install mpd mpc # install music player daemon
```
#### Adding a radio playlist

```shell
mkdir playlists
cd playlists
```

Create a file containing radio station URLs. Only radio stations with auto play on, are allowed in this file. Find a list of german radio station's [here](https://www.chip.de/artikel/Webradio-Live-Stream-Alle-Sender-im-ueberblick_139924359.html){:target="_blank"}.

Download the station file used in this project <a href="../files/stations.txt" download>here</a>.

```shell
nano radiostations.m3u
```
Edit mpd's configuration file to use the previously created playlist, allow Node-RED to access mpd's websocket and set the default sound device to be used as output.

```shell
sudo nano /etc/mpd.conf
```
1. Set ```playlist_directory``` to  ```/home/pi/radio/playlists```
2. Set ```bind_to_address``` to ```any```  
3. Set ```follow_outside_symlinks``` to ```yes```  
4. Set ```aollow_inside_symlinks``` to```yes```
5. Set the default audio device 

```conf
audio_output {
        type            "alsa"
        name            "My ALSA Device"
        device          "sysdefault:CARD=Headphones" # default sound device plugged into the 3.5mm jack
#       mixer_type      "hardware"      
#       mixer_device    "default"       
        mixer_control   "PCM"
#       mixer_index     "0"             
}
```



Restart your Pi before proceeding.

```shell
sudo restart
```
Your radio playlist is now ready to be used. Here is a list of terminal commands to interact with your radio station.

```shell
mpc clear # to clear the database
mpc load radiostations # to load the file containing your URLs
mpc play # to start playing the radiostations in that file from the start
mpc stop # to stop the radio from playing
mpc status # to see the player's status, including what station and what song is currently playing
```


### Add intents

```conf
[StartRadio]
mach das radio an
radio an

[StopRadio]
mach das radio aus
radio aus

[NextRadio]
nächster sender
nächste station

[PrevRadio]
vorherige station
zurück
```

After training click ```View``` and then ```Confirm Guesses``` to accept pronunciation for unknown words.

### Example sentences

```
1. mach das radio an (turn the radio on) 
2. mach das radio aus (turn the radio off) 
3. nächster sender (skip to the next station)
4. vorherige sation (skip to the previous station)
```

### Node-RED flow creation

The music player daemon come with its own custom Node-RED node. The node can be downloaded by accessing Node-RED's header menu an clicking on ```manage palette```, search for ```mpd``` and press ```install```. The node take inputs similar to the terminal commands mentioned above. Make sure to set the mpd server to ``` <pi-ip>:6600``` 

<img src="../img/mpd_install.png" style="max-width: 75%;"/>

The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. The function nodes contain javascript code, responsible for preparing mpd commands.

<img src="../img/flow_radio.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_radio.json" download>Download flow as json file</a>
 
<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "a65a3a94.635d98",
        "type": "tab",
        "label": "Radio",
        "disabled": false,
        "info": ""
    },
    {
        "id": "37099153.cea5fe",
        "type": "switch",
        "z": "a65a3a94.635d98",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "StartRadio",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "StopRadio",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "NextRadio",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "PrevRadio",
                "vt": "str"
            }
        ],
        "checkall": "false",
        "repair": false,
        "outputs": 4,
        "x": 390,
        "y": 480,
        "wires": [
            [
                "662066d6.989f48"
            ],
            [
                "50c4049.493b47c"
            ],
            [
                "d5e23fa3.ebb8c"
            ],
            [
                "e0a6ed62.e089a"
            ]
        ]
    },
    {
        "id": "44c01fb6.28dc9",
        "type": "mpd out",
        "z": "a65a3a94.635d98",
        "name": "",
        "topic": "",
        "server": "9a410553.e09e3",
        "x": 980,
        "y": 460,
        "wires": [
            []
        ]
    },
    {
        "id": "b4e35915.2663c8",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "on",
        "func": "return msg = {payload : \"play\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 890,
        "y": 380,
        "wires": [
            [
                "44c01fb6.28dc9"
            ]
        ]
    },
    {
        "id": "50c4049.493b47c",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "off",
        "func": "return msg = {payload : \"stop\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 570,
        "y": 460,
        "wires": [
            [
                "44c01fb6.28dc9",
                "6a0f4fa7.6115a8"
            ]
        ]
    },
    {
        "id": "d5e23fa3.ebb8c",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "next",
        "func": "return msg = {payload : \"next\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 570,
        "y": 500,
        "wires": [
            [
                "44c01fb6.28dc9"
            ]
        ]
    },
    {
        "id": "6a0f4fa7.6115a8",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "clear",
        "func": "return msg = {payload : \"clear\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 730,
        "y": 440,
        "wires": [
            [
                "44c01fb6.28dc9"
            ]
        ]
    },
    {
        "id": "662066d6.989f48",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "load",
        "func": "return msg = {payload : \"load radiostations\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 570,
        "y": 420,
        "wires": [
            [
                "44c01fb6.28dc9",
                "e58a2ff3.691f78"
            ]
        ]
    },
    {
        "id": "e58a2ff3.691f78",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "repeat",
        "func": "return msg = {payload : \"repeat 1\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 730,
        "y": 400,
        "wires": [
            [
                "b4e35915.2663c8",
                "44c01fb6.28dc9"
            ]
        ]
    },
    {
        "id": "e0a6ed62.e089a",
        "type": "function",
        "z": "a65a3a94.635d98",
        "name": "prev",
        "func": "return msg = {payload : \"previous\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 570,
        "y": 540,
        "wires": [
            [
                "44c01fb6.28dc9"
            ]
        ]
    },
    {
        "id": "d73f5b04.9b3e6",
        "type": "websocket in",
        "z": "a65a3a94.635d98",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 160,
        "y": 480,
        "wires": [
            [
                "37099153.cea5fe"
            ]
        ]
    },
    {
        "id": "9a410553.e09e3",
        "type": "mpd-server",
        "host": "192.168.0.177",
        "port": "6600"
    },
    {
        "id": "5999adec.e962a4",
        "type": "websocket-listener",
        "path": "ws://192.168.0.177:12101/api/events/intent",
        "wholemsg": "true"
    }
]
```
</details>



[Continue with alarm and timer skill implementation](skill-alarm-timer.html)