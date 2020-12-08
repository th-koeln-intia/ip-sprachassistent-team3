---
layout: default
title: Proof Of Concept
nav_order: 3
parent: Setup
---

<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Proof Of Concept

We have chosen the intent "Turning on the light" as our proof of concept, i.e. as proof that our voice assistant works.

## Turning on the light

### Brief example

![nodered1](../assets/nodered1.png)

This is the complete flow.

```json

        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "SetLight",
                "vt": "str"
            }
        ],
        "checkall": "false",
        "repair": false,
        "outputs": 1,
        "x": 380,
        "y": 260,
        "wires": [
            [
                "eb62016c.179b"
            ]
        ]
    },
    {
        "id": "eb62016c.179b",
        "type": "switch",
        "z": "655c582a.4883e8",
        "name": "an/aus",
        "property": "slots.state",
        "propertyType": "msg",
        "rules": [
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
        "outputs": 2,
        "x": 530,
        "y": 260,
        "wires": [
            [
                "9498275a.436018"
            ],
            [
                "21cae0c.5aa5f2"
            ]
        ]
    },
    {
        "id": "9498275a.436018",
        "type": "template",
        "z": "655c582a.4883e8",
        "name": "on",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n  \"state\": \"ON\",\n  \"transition\": 2\n}",
        "output": "json",
        "x": 670,
        "y": 240,
        "wires": [
            [
                "c9b48ebe.96e4c"
            ]
        ]
    },
    {
        "id": "21cae0c.5aa5f2",
        "type": "template",
        "z": "655c582a.4883e8",
        "name": "off",
        "field": "payload",
        "fieldType": "msg",
        "format": "json",
        "syntax": "plain",
        "template": "{\n  \"state\": \"OFF\",\n  \"transition\": 2\n}",
        "output": "json",
        "x": 670,
        "y": 280,
        "wires": [
            [
                "c9b48ebe.96e4c"
            ]
        ]
    },
    {
        "id": "c9b48ebe.96e4c",
        "type": "mqtt out",
        "z": "655c582a.4883e8",
        "name": "mqqt set Lampe",
        "topic": "zigbee2mqtt/Lampe/set",
        "qos": "",
        "retain": "",
        "broker": "e4b2ae7a.7f898",
        "x": 840,
        "y": 260,
        "wires": []
    },
    {
        "id": "f444d71d.abe328",
        "type": "websocket-listener",
        "path": "ws://raspberrypi:12101/api/events/intent",
        "wholemsg": "true"
    },
    {
        "id": "e4b2ae7a.7f898",
        "type": "mqtt-broker",
        "name": "rhasspy mqtt",
        "broker": "raspberrypi",
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

## Setting a timer

## Setting an alarm
