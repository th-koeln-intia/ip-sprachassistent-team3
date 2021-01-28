---
layout: default
title: Getting the time
nav_order: 7
parent: Custom Intents
---

<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Getting the time

One of the most basic skills a VA should have is to tell you what time it is. Here is how.

## Intents

## Complete flow

![flowimage](../assets/flow_time.png)

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

```json
[
    {
        "id": "4f37bc43.98f79c",
        "type": "tab",
        "label": "Time Flow",
        "disabled": false,
        "info": ""
    },
    {
        "id": "1d914531.46bd13",
        "type": "websocket in",
        "z": "4f37bc43.98f79c",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 220,
        "y": 260,
        "wires": [
            [
                "6fb4a645.3efb6"
            ]
        ]
    },
    {
        "id": "6fb4a645.3efb6",
        "type": "switch",
        "z": "4f37bc43.98f79c",
        "name": "",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "GetTime",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 1,
        "x": 380,
        "y": 260,
        "wires": [
            [
                "46fb964a.dae07"
            ]
        ]
    },
    {
        "id": "46fb964a.dae07",
        "type": "function",
        "z": "4f37bc43.98f79c",
        "name": "getCurrentTime",
        "func": "var today = new Date();\nvar time = today.getHours() + \" Uhr \" + today.getMinutes();\nmsg = { payload: \"Es ist \" + time };\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 560,
        "y": 260,
        "wires": [
            [
                "e889dc41.c09098"
            ]
        ]
    },
    {
        "id": "e889dc41.c09098",
        "type": "http request",
        "z": "4f37bc43.98f79c",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://raspberrypi:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 750,
        "y": 260,
        "wires": [
            []
        ]
    },
    {
        "id": "5999adec.e962a4",
        "type": "websocket-listener",
        "path": "ws://raspberrypi:12101/api/events/intent",
        "wholemsg": "true"
    }
]
```