---
layout: default
title: Getting information
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

# Getting information

We want our VA to be able to answer questions that the user might have on any given topic. For this, we have decided on using this [Wikipedia API](https://de.wikipedia.org/api/rest_v1/page/summary/).

## Flow features

- Request information regarding any topic that is available on Wikipedia

## Complete flow

![flowimage](../assets/flow_wikipedia.png)

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

```json
[
    {
        "id": "3d7b9f59.962538",
        "type": "tab",
        "label": "Wiki Flow",
        "disabled": false,
        "info": ""
    },
    {
        "id": "a592411a.23bfc8",
        "type": "function",
        "z": "3d7b9f59.962538",
        "name": "Extract Information from API",
        "func": "msg = {payload: msg.payload.extract}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 720,
        "y": 320,
        "wires": [
            [
                "7dbafca.8ab5a04"
            ]
        ]
    },
    {
        "id": "c6940854.1df588",
        "type": "websocket in",
        "z": "3d7b9f59.962538",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 120,
        "y": 240,
        "wires": [
            [
                "8aeaf34e.a2026"
            ]
        ]
    },
    {
        "id": "8aeaf34e.a2026",
        "type": "switch",
        "z": "3d7b9f59.962538",
        "name": "Intent Switch",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "WikipediaInfo",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 1,
        "x": 290,
        "y": 240,
        "wires": [
            [
                "e0245599.6858d8"
            ]
        ]
    },
    {
        "id": "621b3b6e.3a5d84",
        "type": "http request",
        "z": "3d7b9f59.962538",
        "name": "Wikipedia API",
        "method": "GET",
        "ret": "obj",
        "paytoqs": "ignore",
        "url": "",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 560,
        "y": 240,
        "wires": [
            [
                "a592411a.23bfc8"
            ]
        ]
    },
    {
        "id": "7dbafca.8ab5a04",
        "type": "http request",
        "z": "3d7b9f59.962538",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://raspberrypi:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 850,
        "y": 240,
        "wires": [
            []
        ]
    },
    {
        "id": "e0245599.6858d8",
        "type": "function",
        "z": "3d7b9f59.962538",
        "name": "Wikipedia URL Creat",
        "func": "msg = {url: \"https://de.wikipedia.org/api/rest_v1/page/summary/\" + msg.slots.topic.replace(/\\b\\w/g, l => l.toUpperCase())}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 420,
        "y": 320,
        "wires": [
            [
                "621b3b6e.3a5d84"
            ]
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
