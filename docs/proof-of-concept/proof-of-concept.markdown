---
layout: default
title: Proof of concept
nav_order: 6
---
<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Proof of concept

This page will include the proof of concept for this project. Goal is do demonstrate a good morning sequence using the skills covered in this documentation.

## Sequence

1. user triggers the good morning intent
2. user gets weather information for his city
3. user gets corona information for his district
3. radio starts playing

## Add intent

```conf
[GoodMorning]
guten morgen 
ich bin wach
```

### Example sentences

```
1. guten morgen (good morning)
2. ich bin wach (im awake)
```

### Node-RED flow

<img src="../img/flow_poc.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_proof-of-concept.json" download>Download flow as json file</a>
 
<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "6f202e71.5b2ff",
        "type": "tab",
        "label": "Good Morning Routine",
        "disabled": false,
        "info": ""
    },
    {
        "id": "cfafcf20.a5eb5",
        "type": "websocket in",
        "z": "6f202e71.5b2ff",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 120,
        "y": 300,
        "wires": [
            [
                "e287dda5.f7e32"
            ]
        ]
    },
    {
        "id": "e287dda5.f7e32",
        "type": "switch",
        "z": "6f202e71.5b2ff",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "GoodMorning",
                "vt": "str"
            }
        ],
        "checkall": "false",
        "repair": false,
        "outputs": 1,
        "x": 270,
        "y": 300,
        "wires": [
            [
                "60380faf.f3b1c8",
                "9856261.9bb56d8"
            ]
        ]
    },
    {
        "id": "60380faf.f3b1c8",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "enable light with 25%",
        "func": "var val = 255 / 100 * 25;\nmsg.payload = { \n    \"state\":\"ON\",\n    \"brightness\": val\n};\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 420,
        "y": 200,
        "wires": [
            [
                "933fb3be.52a15"
            ]
        ]
    },
    {
        "id": "933fb3be.52a15",
        "type": "mqtt out",
        "z": "6f202e71.5b2ff",
        "name": "lamp",
        "topic": "zigbee2mqtt/0x00158d000520ac5e/set",
        "qos": "",
        "retain": "",
        "broker": "14b868fb.a55b7f",
        "x": 650,
        "y": 180,
        "wires": []
    },
    {
        "id": "9856261.9bb56d8",
        "type": "change",
        "z": "6f202e71.5b2ff",
        "name": "set default city gummersbach",
        "rules": [
            {
                "t": "set",
                "p": "location.city",
                "pt": "msg",
                "to": "Gummersbach",
                "tot": "str"
            },
            {
                "t": "set",
                "p": "location.country",
                "pt": "msg",
                "to": "germany",
                "tot": "str"
            }
        ],
        "action": "",
        "property": "",
        "from": "",
        "to": "",
        "reg": false,
        "x": 300,
        "y": 360,
        "wires": [
            [
                "86a8cac8.6bacf"
            ]
        ]
    },
    {
        "id": "86a8cac8.6bacf",
        "type": "openweathermap",
        "z": "6f202e71.5b2ff",
        "name": "",
        "wtype": "forecast",
        "lon": "",
        "lat": "",
        "city": "",
        "country": "",
        "language": "de",
        "x": 290,
        "y": 420,
        "wires": [
            [
                "6f33f261.a94e84"
            ]
        ]
    },
    {
        "id": "6f33f261.a94e84",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "",
        "func": "msg = {payload: \"Guten Morgen. Hier ist das Wetter für \" + msg.location.city + \": \" +  msg.payload[0].weather[0].description + \", bei \" + Math.round(msg.payload[0].main.temp) + \" Grad. Die Luftfeuchtigkeit beträgt: \" + msg.payload[0].main.humidity + \" %.\"};\nreturn msg;\n\n\n\n\n/*\nmsg = {payload: \"Hier ist das Wetter für \" + msg.payload.location + \": \" +  msg.payload.detail + \", bei \" + Math.round(msg.payload.tempc) + \" Grad. Die Luftfeuchtigkeit beträgt: \" + msg.payload.humidity + \" %.\"};\nreturn msg;\n*/",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 280,
        "y": 480,
        "wires": [
            [
                "c447476c.554c48"
            ]
        ]
    },
    {
        "id": "c447476c.554c48",
        "type": "http request",
        "z": "6f202e71.5b2ff",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 530,
        "y": 440,
        "wires": [
            [
                "de3510d5.39afe8"
            ]
        ]
    },
    {
        "id": "a4949dde.9bbe9",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "load",
        "func": "return msg = {payload : \"load radiostations\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 790,
        "y": 300,
        "wires": [
            [
                "9fc14c56.00a408",
                "296d41ec.92854e"
            ]
        ]
    },
    {
        "id": "296d41ec.92854e",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "repeat",
        "func": "return msg = {payload : \"repeat 1\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 870,
        "y": 220,
        "wires": [
            [
                "d4aa9580.8ec3e",
                "9fc14c56.00a408"
            ]
        ]
    },
    {
        "id": "d4aa9580.8ec3e",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "on",
        "func": "return msg = {payload : \"play\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 950,
        "y": 160,
        "wires": [
            [
                "9fc14c56.00a408"
            ]
        ]
    },
    {
        "id": "9fc14c56.00a408",
        "type": "mpd out",
        "z": "6f202e71.5b2ff",
        "name": "",
        "topic": "",
        "server": "9a410553.e09e3",
        "x": 960,
        "y": 360,
        "wires": [
            []
        ]
    },
    {
        "id": "de3510d5.39afe8",
        "type": "http request",
        "z": "6f202e71.5b2ff",
        "name": "request info from api",
        "method": "GET",
        "ret": "obj",
        "paytoqs": "ignore",
        "url": "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?outFields=*&where=%20(BEZ%20%3D%20'Landkreis'%20OR%20BEZ%20%3D%20'Kreis'%20OR%20BEZ%20%3D%20'Kreisfreie%20Stadt'%20OR%20BEZ%20%3D%20'Bezirk')%20&f=json",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 620,
        "y": 360,
        "wires": [
            [
                "b0fbe5ae.31382"
            ]
        ]
    },
    {
        "id": "b0fbe5ae.31382",
        "type": "function",
        "z": "6f202e71.5b2ff",
        "name": "build tts",
        "func": "for(i = 0; i < msg.payload.features.length; i++) {\n    if(\"Oberbergischer Kreis\".toLowerCase() === msg.payload.features[i].attributes.GEN.toLowerCase()) \n    {\n        msg.payload = \"Hier sind die Korona Informationen für den Oberbergischen Kreis: es gab insgesamt \" + msg.payload.features[i].attributes.cases + \" Fälle von Korona, davon sind \" + msg.payload.features[i].attributes.cases7_lk + \" in den letzten 7 Tagen aufgetreten. Gestorben sind insgesamt \" + msg.payload.features[i].attributes.deaths + \" Menschen, davon \" + msg.payload.features[i].attributes.death7_lk + \" in den letzten 7 Tagen. Die 7 Tage Inzidenz liegt bei \" + msg.payload.features[i].attributes.cases7_per_100k_txt;\n        return msg;\n        \n    }\n}\nmsg.payload = \"Fehler\";\nreturn msg;\n\n//msg.slots.district.toLowerCase()",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 620,
        "y": 300,
        "wires": [
            [
                "426233a5.0cebbc"
            ]
        ]
    },
    {
        "id": "426233a5.0cebbc",
        "type": "http request",
        "z": "6f202e71.5b2ff",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 690,
        "y": 260,
        "wires": [
            [
                "a4949dde.9bbe9"
            ]
        ]
    },
    {
        "id": "5999adec.e962a4",
        "type": "websocket-listener",
        "path": "ws://192.168.0.177:12101/api/events/intent",
        "wholemsg": "true"
    },
    {
        "id": "14b868fb.a55b7f",
        "type": "mqtt-broker",
        "name": "Intern MQTT",
        "broker": "192.168.0.177",
        "port": "12183",
        "clientid": "",
        "usetls": false,
        "compatmode": false,
        "keepalive": "60",
        "cleansession": true,
        "birthTopic": "",
        "birthQos": "0",
        "birthPayload": "",
        "closeTopic": "",
        "closeQos": "0",
        "closePayload": "",
        "willTopic": "",
        "willQos": "0",
        "willPayload": ""
    },
    {
        "id": "9a410553.e09e3",
        "type": "mpd-server",
        "host": "192.168.0.177",
        "port": "6600"
    }
]
```
</details>




