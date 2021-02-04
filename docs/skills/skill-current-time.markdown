---
layout: default
parent: Skills
title: Current time
nav_order: 4
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

# Current time

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to receive current time information.

### Add intents

```conf
[GetTime]
wie spät ist es
sag mir die uhrzeit
uhrzeit
wie viel uhr ist es
```

### Example sentences

```
1. wie spät ist es (what time is it)
2. sag mir die uhrzeit (tell me the current time)
```

### Node-RED flow creation

 The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. All template nodes  contain json formatted statements to control features of your light bulb.  
 The ```generate time string``` function node contains javascript code, which extracts time information from the operating system. 
```
var today = new Date();
var time = today.getHours() + " Uhr " + today.getMinutes();
msg = { payload: "Es ist " + time };
return msg;
```
The time information is then passed to [Rhasspy's text to speech API](/skills/intro/skill-nodered-intro.html#accessing-rhasspys-text-to-speech-api){:target="_blank"}.

<img src="../img/flow_time.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_current-time.json" download>Download flow as json file</a>

<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "48004b8d.6f1d24",
        "type": "tab",
        "label": "Time",
        "disabled": false,
        "info": ""
    },
    {
        "id": "608ed535.15eb7c",
        "type": "function",
        "z": "48004b8d.6f1d24",
        "name": "generate time string",
        "func": "var today = new Date();\nvar time = today.getHours() + \" Uhr \" + today.getMinutes();\nmsg = { payload: \"Es ist \" + time };\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 580,
        "y": 240,
        "wires": [
            [
                "cc5de36a.afec6"
            ]
        ]
    },
    {
        "id": "cc5de36a.afec6",
        "type": "http request",
        "z": "48004b8d.6f1d24",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 790,
        "y": 240,
        "wires": [
            []
        ]
    },
    {
        "id": "a6bc54e.66deca8",
        "type": "switch",
        "z": "48004b8d.6f1d24",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "GetTime",
                "vt": "str"
            }
        ],
        "checkall": "false",
        "repair": false,
        "outputs": 1,
        "x": 370,
        "y": 240,
        "wires": [
            [
                "608ed535.15eb7c"
            ]
        ]
    },
    {
        "id": "38886150.c2667e",
        "type": "websocket in",
        "z": "48004b8d.6f1d24",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 200,
        "y": 240,
        "wires": [
            [
                "a6bc54e.66deca8"
            ]
        ]
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

[Continue with weather forecast skill implementation](skill-weather.html)