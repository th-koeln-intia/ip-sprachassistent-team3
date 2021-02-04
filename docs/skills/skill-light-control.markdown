---
layout: default
parent: Skills
title: Light control
nav_order: 3
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

# Light control 

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to enable light control. 

1. Turn light on / off
2. Set light's brightness
3. Set light's color temperature

### Add intents

```conf
[ChangeLightState]
light_name = (wohnzimmerlampe | garagenlicht){name}
light_state = (ein | an | aus) {state}
schalte (die | das) <light_name> <light_state>
licht <light_state>

[ChangeBrightness]
(stelle | setze) [die] helligkeit auf (1..100){percent!int} [prozent]

[ChangeTemp]
(stelle | setze) [die] temperatur auf (kalt | warm){temp}
```
### Example sentences

```
1. stelle die wohnzimmerlampe aus (turn the living room lamp off)
2. stelle die helligkeit auf 10 prozent (set the brightness to 10 percent)
3. stelle die temperatur auf warm (set the temperature to warm)
```

### Node-RED flow creation
Features for your smart device can be found [here](https://www.zigbee2mqtt.io/information/supported_devices.html){:target="_blank"}.
[Aqara LED Light Bulb](https://www.zigbee2mqtt.io/devices/ZNLDP12LM.html){:target="_blank"} supports the following features: ```state```, ```brightness``` & ```color_temp```.
 
 The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. All template nodes  contain json formatted statements to control features of your light bulb.  
 The ```set brightness``` function node contains javascript code, which scales the passed percentage to fit the lights brightness scale.
```
var val = 255 / 100 * msg.slots.percent;
msg.payload = { 
    "state":"ON",
    "brightness": val
};
return msg;
```
 Put the address of Rhasspy's internal MQTT broker ```<pi's-ip>:12183``` and your lights ZigBee topic ```zigbee2mqtt/FRIENDLY_NAME/set``` into the ```mqtt out``` node to enable communication with your smart device.

   
<img src="../img/flow_light-control.png" style="max-width: 100%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_light-control.json" download>Download flow as json file</a>
<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "86964d6.3cc53b",
        "type": "tab",
        "label": "Lightcontrol",
        "disabled": false,
        "info": ""
    },
    {
        "id": "6b955ac.e921624",
        "type": "websocket in",
        "z": "86964d6.3cc53b",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 180,
        "y": 300,
        "wires": [
            [
                "88648a4f.4c0ad8"
            ]
        ]
    },
    {
        "id": "a41d16ba.61ed68",
        "type": "template",
        "z": "86964d6.3cc53b",
        "name": "turn off",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n    \"state\":\"OFF\"\n}",
        "output": "json",
        "x": 710,
        "y": 400,
        "wires": [
            [
                "7ebe2e46.54f6a8"
            ]
        ]
    },
    {
        "id": "728c4843.cc97d8",
        "type": "template",
        "z": "86964d6.3cc53b",
        "name": "turn on",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n    \"state\":\"ON\"\n}",
        "output": "json",
        "x": 720,
        "y": 360,
        "wires": [
            [
                "7ebe2e46.54f6a8"
            ]
        ]
    },
    {
        "id": "6bc90460.b848dc",
        "type": "switch",
        "z": "86964d6.3cc53b",
        "name": "check temp",
        "property": "slots.temp",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "warm",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "kalt",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 2,
        "x": 530,
        "y": 300,
        "wires": [
            [
                "d963cc19.d2dd18"
            ],
            [
                "9dcfd09d.b9c0c"
            ]
        ]
    },
    {
        "id": "d963cc19.d2dd18",
        "type": "template",
        "z": "86964d6.3cc53b",
        "name": "set warm",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n    \"state\":\"ON\",\n    \"color_temp\":500\n}",
        "output": "json",
        "x": 720,
        "y": 280,
        "wires": [
            [
                "7ebe2e46.54f6a8"
            ]
        ]
    },
    {
        "id": "9dcfd09d.b9c0c",
        "type": "template",
        "z": "86964d6.3cc53b",
        "name": "set cold",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n    \"state\":\"ON\",\n    \"color_temp\":150\n}",
        "output": "json",
        "x": 720,
        "y": 320,
        "wires": [
            [
                "7ebe2e46.54f6a8"
            ]
        ]
    },
    {
        "id": "d4774b2e.745628",
        "type": "mqtt out",
        "z": "86964d6.3cc53b",
        "name": "lamp",
        "topic": "zigbee2mqtt/0x00158d000520ac5e/set",
        "qos": "",
        "retain": "",
        "broker": "14b868fb.a55b7f",
        "x": 1230,
        "y": 320,
        "wires": []
    },
    {
        "id": "88648a4f.4c0ad8",
        "type": "switch",
        "z": "86964d6.3cc53b",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "ChangeBrightness",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "ChangeTemp",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "ChangeLightState",
                "vt": "str"
            }
        ],
        "checkall": "false",
        "repair": false,
        "outputs": 3,
        "x": 350,
        "y": 300,
        "wires": [
            [
                "dafb6ccd.ae6f5"
            ],
            [
                "6bc90460.b848dc"
            ],
            [
                "4c371a21.6afe04"
            ]
        ]
    },
    {
        "id": "4c371a21.6afe04",
        "type": "switch",
        "z": "86964d6.3cc53b",
        "name": "check on or off",
        "property": "slots.state",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "ein",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "an",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "aus",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 3,
        "x": 520,
        "y": 380,
        "wires": [
            [
                "728c4843.cc97d8"
            ],
            [
                "728c4843.cc97d8"
            ],
            [
                "a41d16ba.61ed68"
            ]
        ]
    },
    {
        "id": "dafb6ccd.ae6f5",
        "type": "function",
        "z": "86964d6.3cc53b",
        "name": "set brightness",
        "func": "var val = 255 / 100 * msg.slots.percent;\nmsg.payload = { \n    \"state\":\"ON\",\n    \"brightness\": val\n};\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 720,
        "y": 220,
        "wires": [
            [
                "7ebe2e46.54f6a8"
            ]
        ]
    },
    {
        "id": "7ebe2e46.54f6a8",
        "type": "switch",
        "z": "86964d6.3cc53b",
        "name": "check room if there is one",
        "property": "slots.room",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "wohnzimmer",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "schlafzimmer",
                "vt": "str"
            },
            {
                "t": "null"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 3,
        "x": 1010,
        "y": 320,
        "wires": [
            [
                "d4774b2e.745628"
            ],
            [],
            [
                "d4774b2e.745628"
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
    }
]
```
</details>

[Continue with current time skill implementation](skill-current-time.html)