---
layout: default
parent: Skills
title: Wikipedia
nav_order: 7
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

# Wikipedia information

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to provide Wikipedia information on a spoken topic. The functionality of this skill is limited , because only topics contained in Rhasspy's sentence file can be used for information retrieval. This skill requires an active internet connection to access Wikipedia's API.

### Add slots

This skill requires a slot list named ```topics```. After creating the slot list add your desired topics. 

Download a list of example topics <a href="../files/topics.txt" download>here</a>. 

### Add intents

```conf
[WikipediaInfo]
erzähl mir etwas über ($topics){topic}
```
After training click ```View``` and then ```Confirm Guesses``` to accept pronunciation for unknown words.

### Example sentences

```
1. erzähl mir etwas über Angela Merkel (tell me something about Angela Merkel) 
```

### Node-RED flow creation

The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. The function node contains javascript code, responsible for creating a query URL using the spoken topic. The created query URL is then used to access Wikipedia's API inside a ```http request``` node. The following function node processes the retrieved information from Wikipedia's API. The topic's information is then passed to [Rhasspy's text to speech API](/skills/intro/skill-nodered-intro.html#accessing-rhasspys-text-to-speech-api){:target="_blank"}.

<img src="../img/flow_wiki.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_wiki.json" download>Download flow as json file</a>

<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "298a30ce.25a2b",
        "type": "tab",
        "label": "Wikipedia",
        "disabled": false,
        "info": ""
    },
    {
        "id": "b076246d.c3aef8",
        "type": "function",
        "z": "298a30ce.25a2b",
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
                "dfe030a0.66b6d8"
            ]
        ]
    },
    {
        "id": "a0f47a0b.5ece78",
        "type": "websocket in",
        "z": "298a30ce.25a2b",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 120,
        "y": 240,
        "wires": [
            [
                "f7a96d64.4dedf8"
            ]
        ]
    },
    {
        "id": "f7a96d64.4dedf8",
        "type": "switch",
        "z": "298a30ce.25a2b",
        "name": "check intent",
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
        "x": 270,
        "y": 240,
        "wires": [
            [
                "34100001.76b8f8"
            ]
        ]
    },
    {
        "id": "5f77b41a.20036c",
        "type": "http request",
        "z": "298a30ce.25a2b",
        "name": "Wikipedia API",
        "method": "GET",
        "ret": "obj",
        "paytoqs": "ignore",
        "url": "",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 480,
        "y": 320,
        "wires": [
            [
                "b076246d.c3aef8"
            ]
        ]
    },
    {
        "id": "34100001.76b8f8",
        "type": "function",
        "z": "298a30ce.25a2b",
        "name": "Wikipedia URL Create",
        "func": "word = msg.slots.topic\nwords = word.split(\" \");\nmsg = {payload: words.length}\nfor(i = 0; i < words.length; i++) {\n    words[i] = words[i][0].toUpperCase() + words[i].substr(1);\n}\nmsg = {url: \"https://de.wikipedia.org/api/rest_v1/page/summary/\" + words.join(\" \")}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 460,
        "y": 240,
        "wires": [
            [
                "5f77b41a.20036c"
            ]
        ]
    },
    {
        "id": "dfe030a0.66b6d8",
        "type": "http request",
        "z": "298a30ce.25a2b",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 810,
        "y": 240,
        "wires": [
            []
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

[Continue with weather radio station skill implementation](skill-radio.html)

