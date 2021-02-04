---
layout: default
parent: Skills
title: Covid info
nav_order: 6
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

# Covid information

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to provide information regarding the current pandemic (February 2021). Information can be retrieved for german [districts](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0){:target="_blank"} and [states](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0){:target="_blank"}. This skill requires a active internet connection to access [Robert Koch Institute's](https://www.rki.de/DE/Home/homepage_node.html){:target="_blank"} Corona API.

1. Get information for current and past week's number of cases & deaths

### Add slots
This skill requires two slot lists one named ```districts``` and another one named ```states```. After creating the slot lists add your desired districts and states.

Download a list containing german districts <a href="../files/districts.txt" download>here</a>.  
Download a list containing german states <a href="../files/states.txt" download>here</a>.

### Add intents

```conf
[CoronaDistrictInfo]
(wie sehen | sag mir) [die] corona zahlen für [den] landkreis ($districts){district} [aus]

[CoronaStateInfo]
(wie sehen | sag mir) [die] corona zahlen für [das] bundesland ($states){state} [aus]
```
Training might take a while depending on your Pi's hardware. If training fails, try adding the sentences one by one.
After training click ```View``` and then ```Confirm Guesses``` to accept pronunciation for unknown words.

### Example sentences

```
1. wie sehen die corona zahlen für das bundesland Nordrhein-Westfalen aus (how do the corona numbers for the state Nordrhein-Westfalen look like)
2. wie sehen die corona zahlen für den landkreis Oberbergischer Kreis aus (how do the corona numbers for the district Oberbergischer Kreis look like)
```

### Node-RED flow creation

The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. Both http request nodes contain a query string designed to retrieve information from Robert Koch Institute's Corona API. The query URLs were created for [districts](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0/geoservice){:target="_blank"} and [states](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0/geoservice){:target="_blank"}. The function nodes contain javascript code, responsible for extracting corona information obtained from Robert Koch Institute's Corona API. Retrieving information may take some time depending on how heavy the API is used. The corona information is then passed to [Rhasspy's text to speech API](/skills/intro/skill-nodered-intro.html#accessing-rhasspys-text-to-speech-api){:target="_blank"}.

<img src="../img/flow_covid.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_covid.json" download>Download flow as json file</a>

<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "773eec76.a182c4",
        "type": "tab",
        "label": "Corona",
        "disabled": false,
        "info": ""
    },
    {
        "id": "1b7fbbb7.d3237c",
        "type": "websocket in",
        "z": "773eec76.a182c4",
        "name": "rhasspy",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 310,
        "y": 340,
        "wires": [
            [
                "5a4ec99f.3ceb9"
            ]
        ]
    },
    {
        "id": "5a4ec99f.3ceb9",
        "type": "switch",
        "z": "773eec76.a182c4",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "CoronaStateInfo",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "CoronaDistrictInfo",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 2,
        "x": 450,
        "y": 340,
        "wires": [
            [
                "17611e61.3612a2"
            ],
            [
                "89d69c90.b6a878"
            ]
        ]
    },
    {
        "id": "17611e61.3612a2",
        "type": "http request",
        "z": "773eec76.a182c4",
        "name": "request info from api",
        "method": "GET",
        "ret": "obj",
        "paytoqs": "ignore",
        "url": "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/Coronaf%C3%A4lle_in_den_Bundesl%C3%A4ndern/FeatureServer/0/query?where=1%3D1&outFields=LAN_ew_GEN,Fallzahl,Death,cases7_bl,death7_bl&outSR=4326&f=json",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 660,
        "y": 320,
        "wires": [
            [
                "f06197fc.8bd28"
            ]
        ]
    },
    {
        "id": "f06197fc.8bd28",
        "type": "function",
        "z": "773eec76.a182c4",
        "name": "build tts",
        "func": "var count=0;\nfor(i = 0; i < msg.payload.features.length; i++) {\n    if(msg.slots.state.toLowerCase() === msg.payload.features[i].attributes.LAN_ew_GEN.toLowerCase()) \n    {\n        msg.payload = \"Hier sind die Korona Informationen für das Bundesland \" + msg.slots.state + \": es gab insgesamt \" + msg.payload.features[i].attributes.Fallzahl + \" Fälle von Korona, davon sind \" + msg.payload.features[i].attributes.cases7_bl + \" in den letzten 7 Tagen aufgetreten. Gestorben sind insgesamt \" + msg.payload.features[i].attributes.Death + \" Menschen, davon \" + msg.payload.features[i].attributes.death7_bl + \" in den letzten 7 Tagen. \";\n        return msg;\n    }\n}\nmsg.payload = \"Fehler\";\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 840,
        "y": 320,
        "wires": [
            [
                "d60d8536.186d98"
            ]
        ]
    },
    {
        "id": "c7251ce9.cdb608",
        "type": "function",
        "z": "773eec76.a182c4",
        "name": "build tts",
        "func": "for(i = 0; i < msg.payload.features.length; i++) {\n    if(msg.slots.district.toLowerCase() === msg.payload.features[i].attributes.GEN.toLowerCase()) \n    {\n        msg.payload = \"Hier sind die Korona Informationen für den Landkreis \" + msg.slots.district + \": es gab insgesamt \" + msg.payload.features[i].attributes.cases + \" Fälle von Korona, davon sind \" + msg.payload.features[i].attributes.cases7_lk + \" in den letzten 7 Tagen aufgetreten. Gestorben sind insgesamt \" + msg.payload.features[i].attributes.deaths + \" Menschen, davon \" + msg.payload.features[i].attributes.death7_lk + \" in den letzten 7 Tagen. Die 7 Tage Inzidenz liegt bei \" + msg.payload.features[i].attributes.cases7_per_100k_txt;\n        return msg;\n        \n    }\n}\nmsg.payload = \"Fehler\";\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 840,
        "y": 360,
        "wires": [
            [
                "d60d8536.186d98"
            ]
        ]
    },
    {
        "id": "d60d8536.186d98",
        "type": "http request",
        "z": "773eec76.a182c4",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 990,
        "y": 340,
        "wires": [
            []
        ]
    },
    {
        "id": "89d69c90.b6a878",
        "type": "http request",
        "z": "773eec76.a182c4",
        "name": "request info from api",
        "method": "GET",
        "ret": "obj",
        "paytoqs": "ignore",
        "url": "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?outFields=*&where=%20(BEZ%20%3D%20'Landkreis'%20OR%20BEZ%20%3D%20'Kreis'%20OR%20BEZ%20%3D%20'Kreisfreie%20Stadt'%20OR%20BEZ%20%3D%20'Bezirk')%20&f=json",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 660,
        "y": 360,
        "wires": [
            [
                "c7251ce9.cdb608"
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
</details>>

[Continue with Wikipedia skill implementation](skill-wiki.html)