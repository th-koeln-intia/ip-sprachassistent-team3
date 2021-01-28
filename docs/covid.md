---
layout: default
title: Receiving news on Covid-19
nav_order: 5
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

# The newest Covid-19 news

At the time of our development, the Covid-19 pandemic still has control over our day to day lives. To adapt to current needs, we have decided to implement an [API by the RKI](https://npgeo-corona-npgeo-de.hub.arcgis.com/) that enables the user to ask our VA for updates specifically regarding Covid-19. All information is provided for states and districts separately.

## Flow features

- Ask for the total number of cases

- Ask for the number of cases in the last seven days

- Ask for the total death toll

- Ask for the death toll of the last seven days

## Example command

"Apollo, wie sehen die Corona Zahlen aus?"

## Complete flow

![flowimage](../assets/flow_covid.png)

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

```json
[
   {
      "id":"7d70f1a6.26893",
      "type":"tab",
      "label":"Flow 2",
      "disabled":false,
      "info":""
   },
   {
      "id":"d4359c76.425b1",
      "type":"websocket in",
      "z":"7d70f1a6.26893",
      "name":"rhasspy",
      "server":"fef0743f.368ac",
      "client":"",
      "x":250,
      "y":340,
      "wires":[
         [
            "5a0497db.a27378"
         ]
      ]
   },
   {
      "id":"5a0497db.a27378",
      "type":"switch",
      "z":"7d70f1a6.26893",
      "name":"",
      "property":"intent.name",
      "propertyType":"msg",
      "rules":[
         {
            "t":"eq",
            "v":"CoronaStateInfo",
            "vt":"str"
         },
         {
            "t":"eq",
            "v":"CoronaDistrictInfo",
            "vt":"str"
         }
      ],
      "checkall":"true",
      "repair":false,
      "outputs":2,
      "x":430,
      "y":340,
      "wires":[
         [
            "657c1bda.c903b4"
         ],
         [
            "a5a058c1.b3fe2"
         ]
      ]
   },
   {
      "id":"c9558304.4d59d",
      "type":"http request",
      "z":"7d70f1a6.26893",
      "name":"TTS",
      "method":"POST",
      "ret":"txt",
      "paytoqs":"ignore",
      "url":"http://192.168.0.177:12101/api/text-to-speech",
      "tls":"",
      "persist":false,
      "proxy":"",
      "authType":"",
      "x":1190,
      "y":340,
      "wires":[
         [
            
         ]
      ]
   },
   {
      "id":"657c1bda.c903b4",
      "type":"http request",
      "z":"7d70f1a6.26893",
      "name":"",
      "method":"GET",
      "ret":"obj",
      "paytoqs":"ignore",
      "url":"https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/Coronaf%C3%A4lle_in_den_Bundesl%C3%A4ndern/FeatureServer/0/query?where=1%3D1&outFields=LAN_ew_GEN,Fallzahl,Death,cases7_bl,death7_bl&outSR=4326&f=json",
      "tls":"",
      "persist":false,
      "proxy":"",
      "authType":"",
      "x":650,
      "y":300,
      "wires":[
         [
            "1daaed6c.274c4b"
         ]
      ]
   },
   {
      "id":"1daaed6c.274c4b",
      "type":"function",
      "z":"7d70f1a6.26893",
      "name":"",
      "func":"var count=0;\nfor(i = 0; i < msg.payload.features.length; i++) {\n    if(msg.slots.state === msg.payload.features[i].attributes.LAN_ew_GEN.toLowerCase()) \n    {\n        msg = {payload: \"Hier sind die Korona Informationen für das Bundesland \" + msg.slots.state + \": es gab insgesamt \" + msg.payload.features[i].attributes.Fallzahl + \" Fälle von Korona, davon sind \" + msg.payload.features[i].attributes.cases7_bl + \" in den letzten 7 Tagen aufgetreten. Gestorben sind insgesamt \" + msg.payload.features[i].attributes.Death + \" Menschen, davon \" + msg.payload.features[i].attributes.death7_bl + \" in den letzten 7 Tagen. \"}\n        break;\n    }\n}\nreturn msg;",
      "outputs":1,
      "noerr":0,
      "initialize":"",
      "finalize":"",
      "x":960,
      "y":300,
      "wires":[
         [
            "c9558304.4d59d"
         ]
      ]
   },
   {
      "id":"a5a058c1.b3fe2",
      "type":"http request",
      "z":"7d70f1a6.26893",
      "name":"",
      "method":"GET",
      "ret":"obj",
      "paytoqs":"ignore",
      "url":"https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=BEZ%20%3D%20'LANDKREIS'&outFields=BEZ,cases,deaths,recovered,cases7_lk,death7_lk,GEN&outSR=4326&f=json",
      "tls":"",
      "persist":false,
      "proxy":"",
      "authType":"",
      "x":650,
      "y":360,
      "wires":[
         [
            "5deeb31b.4a0e0c"
         ]
      ]
   },
   {
      "id":"5deeb31b.4a0e0c",
      "type":"function",
      "z":"7d70f1a6.26893",
      "name":"",
      "func":"for(i = 0; i < msg.payload.features.length; i++) {\n    if(msg.slots.district === msg.payload.features[i].attributes.GEN.toLowerCase()) \n    {\n        msg = {payload: \"Hier sind die Korona Informationen für den Landkreis \" + msg.slots.district + \": es gab insgesamt \" + msg.payload.features[i].attributes.cases + \" Fälle von Korona, davon sind \" + msg.payload.features[i].attributes.cases7_lk + \" in den letzten 7 Tagen aufgetreten. Gestorben sind insgesamt \" + msg.payload.features[i].attributes.deaths + \" Menschen, davon \" + msg.payload.features[i].attributes.death7_lk + \" in den letzten 7 Tagen. \"}\n        break;\n    }\n}\nreturn msg;",
      "outputs":1,
      "noerr":0,
      "initialize":"",
      "finalize":"",
      "x":960,
      "y":360,
      "wires":[
         [
            "c9558304.4d59d"
         ]
      ]
   },
   {
      "id":"fef0743f.368ac",
      "type":"websocket-listener",
      "path":"ws://192.168.0.177:12101/api/events/intent",
      "wholemsg":"true"
   }
]
```