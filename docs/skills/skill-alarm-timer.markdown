---
layout: default
parent: Skills
title: Alarm & Timer
nav_order: 9
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

# Alarm & timer 

This skill implementation follows steps explained on the [intro page](intro/skill-intro.html){:target="_blank"} to enable a alarm and timer function. This features requires a performing [radio station](skill-radio.html){:target="_blank"}.

1. Create a alarm (no duplicates accepted)
2. Delete a alarm
3. Stop a activated alarm 
4. Start a timer (feedback available after timer has run out)
5. Get information for a timers remaining time


### Add intent

```shell
[setAlarm]
wecke mich um (0..23){alarm_hour!int} uhr [(1..59){alarm_minute!int}]
stell einen wecker für (0..23){alarm_hour!int} uhr [(1..59){alarm_minute!int}]

[stopAlarm]
stop
ruhe
hör auf
sei leise

[deleteAlarm]
lösche [den] (0..23){alarm_hour!int} uhr [(1..59){alarm_minute!int}] (alarm | wecker)

[getRemainingTime]
wie lange läuft der timer [noch]

[setTimer]
([(1..24){timer_hour!int} (stunde|stunden)] [(1..59){timer_minute!int} (minuten|minute)] [(1..59){timer_second!int} (sekunden|sekunde)] timer)
stelle einen [(1..24){timer_hour!int} (stunde|stunden)] [(1..59){timer_minute!int} (minuten|minute)] [(1..59){timer_second!int} (sekunden|sekunde)] timer
```

Training might take a while depending on your Pi's hardware. If training fails, try adding the sentences one by one.
After training click ```View``` and then ```Confirm Guesses``` to accept pronunciation for unknown words.

### Example sentences

```
1. stell einen wecker für 20 uhr 20 (set a alarm for 04:20 pm)
2. stop (stop the ringing alarm)
3. lösche den 20 uhr 20 alarm (delete the alarm set for 04:20 pm)
4. stelle einen 20 minuten timer (set a 20 minute timer)
5. wie lange läuft der timer (when will the timer run out)
```
## Alarm and timer database

Alarm and timer information is stored inside a sql lite database file called ```timer.db```. This files needs to be important into your Node-RED directory. Follow the steps below to import the file from this project's github page. 

```shell
cd /home/pi/node-red/data
mkdir sqllite
cd sqllite
wget wget https://github.com/th-koeln-intia/ip-sprachassistent-team3/raw/master/data/node%20red/sqllite/timer.db
```

### Node-RED flow creation

A custom ```sqlite``` Node-RED node is required to pass and read data from the alarm and timer database. The node can be downloaded by accessing Node-RED's header menu an clicking on ```manage palette```, search for ```sqlite``` and press ```install```.

<img src="../img/sqllite_install.png" style="max-width: 75%;"/>

The ```web socket in``` node waits for an intent to be spoken. After an intent is recognized a json structured payload is passed to the first switch called ```check intent```. This switch passes the information to the next node depending on the intent name associated with the spoken intent. The function nodes contain javascript code, responsible for preparing sql statements to be send to the sqlite nodes. A inject node is triggered every 0.1 seconds to scan the database for time events. A active alarm starts the radio station and a ending timer triggers a notification.

<img src="../img/flow_alarm-timer.png" style="max-width: 150%;"/>

Download the json file associated with this flow and import it into Node-RED using the header menu to get a deeper look into this skill.

<a href="../files/flow_alarm-timer.json" download>Download flow as json file</a>

<details closed markdown="block">
  <summary>
    JSON
  </summary>
```conf
[
    {
        "id": "d138947f.fd823",
        "type": "tab",
        "label": "Alarm and Timer",
        "disabled": false,
        "info": ""
    },
    {
        "id": "2f4b42af.6fdbb6",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "check timer and delete",
        "func": "currentDate = new Date();\ncurrentDate.setMilliseconds(0);\n\nfor(var i = 0; i < msg.payload.length; i += 1) {\n    \n    timerDate = new Date(msg.payload[i].year, (msg.payload[i].month - 1), msg.payload[i].day, (msg.payload[i].hour), msg.payload[i].minute, msg.payload[i].second);\n    timerDate.setMilliseconds(0);\n    \n    if(timerDate.getTime() == currentDate.getTime())\n    return msg = {  topic: \"DELETE FROM timer WHERE timer_id = \" + msg.payload[i].timer_id + \";\",\n                    alarm: msg.payload[i].alarm};\n    \n    else if(timerDate < currentDate)\n    return msg = {  topic: \"DELETE FROM timer WHERE timer_id = \" + msg.payload[i].timer_id + \";\",\n                    notification: \"Vorhandener Timer ist während des Neustarts abgelaufen.\"};\n}",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;\nvar timerDate;",
        "finalize": "",
        "x": 740,
        "y": 260,
        "wires": [
            [
                "d6ea68c9.b13b5",
                "f4325816.6e8fd"
            ]
        ]
    },
    {
        "id": "1d1c5588.1d73c2",
        "type": "inject",
        "z": "d138947f.fd823",
        "name": "checking for timers",
        "props": [
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "1",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "SELECT timer_id, strftime('%H',time) as hour, strftime('%M',time) as minute, strftime('%S',time) as second, strftime('%d',time) as day, strftime('%m',time) as month, strftime('%Y',time) as year, alarm FROM timer;",
        "x": 460,
        "y": 360,
        "wires": [
            [
                "d6ea68c9.b13b5"
            ]
        ]
    },
    {
        "id": "d6ea68c9.b13b5",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 680,
        "y": 320,
        "wires": [
            [
                "2f4b42af.6fdbb6",
                "83cc3c71.6a41d8"
            ]
        ]
    },
    {
        "id": "83cc3c71.6a41d8",
        "type": "switch",
        "z": "d138947f.fd823",
        "name": "check for notification",
        "property": "notification",
        "propertyType": "msg",
        "rules": [
            {
                "t": "nnull"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 1,
        "x": 1220,
        "y": 360,
        "wires": [
            [
                "d7fab366.05313"
            ]
        ]
    },
    {
        "id": "3f8c9b9e.d42ea4",
        "type": "switch",
        "z": "d138947f.fd823",
        "name": "check intent",
        "property": "intent.name",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "setAlarm",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "setTimer",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "getRemainingTime",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "deleteAlarm",
                "vt": "str"
            },
            {
                "t": "eq",
                "v": "stopAlarm",
                "vt": "str"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 5,
        "x": 250,
        "y": 540,
        "wires": [
            [
                "47f0f61a.e02eb8"
            ],
            [
                "5e3c7fd.a570e8"
            ],
            [
                "f0960b48.50cdd"
            ],
            [
                "31a2c467.0e3444"
            ],
            [
                "2865faf1.28970e"
            ]
        ]
    },
    {
        "id": "5e3c7fd.a570e8",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build insert statement",
        "func": "date = new Date();\n\n\nif( !msg.slots.timer_hour )\n    msg.slots.timer_hour = 0;\n    \nif( !msg.slots.timer_minute )\n    msg.slots.timer_minute = 0;\n    \nif( !msg.slots.timer_second )\n    msg.slots.timer_second = 0;\n\ndate.setHours((date.getHours()) + msg.slots.timer_hour);\ndate.setMinutes(date.getMinutes() + msg.slots.timer_minute);\ndate.setSeconds(date.getSeconds() + msg.slots.timer_second);\n\nif(msg.slots.timer_hour == 1) hourStr = \" Stunde, \";\nelse hourStr = \" Stunden, \";\n\nif(msg.slots.timer_minute == 1) minuteStr = \" Minute und \";\nelse minuteStr = \" Minuten und \";\n\nif(msg.slots.timer_second == 1) secondStr = \" Sekunde.\";\nelse secondStr = \" Sekunden.\";\n\nreturn msg = {  topic: \"INSERT INTO timer (time, alarm) VALUES (datetime('\" + date.getFullYear() + \"-\" + ('0' + (date.getMonth() + 1)).slice(-2) + \"-\" + ('0' + date.getDate()).slice(-2) + \" \"+ ('0' + date.getHours()).slice(-2) + \":\" + ('0' + date.getMinutes()).slice(-2) + \":\" + ('0' + date.getSeconds()).slice(-2) + \"'), 0);\",\n                notification: \"Teimer gestellt für \" + msg.slots.timer_hour + hourStr + msg.slots.timer_minute + minuteStr + msg.slots.timer_second + secondStr};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var date;\n\nvar hourStr;\nvar minuteStr;\nvar secondStr;",
        "finalize": "",
        "x": 460,
        "y": 460,
        "wires": [
            [
                "ccf13712.ad0298"
            ]
        ]
    },
    {
        "id": "f4325816.6e8fd",
        "type": "switch",
        "z": "d138947f.fd823",
        "name": "check if alarm or timer",
        "property": "alarm",
        "propertyType": "msg",
        "rules": [
            {
                "t": "eq",
                "v": "1",
                "vt": "num"
            },
            {
                "t": "eq",
                "v": "0",
                "vt": "num"
            }
        ],
        "checkall": "true",
        "repair": false,
        "outputs": 2,
        "x": 1000,
        "y": 260,
        "wires": [
            [
                "d9f6eede.07ca"
            ],
            [
                "e2302041.5c8c6"
            ]
        ]
    },
    {
        "id": "f0960b48.50cdd",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build select statement",
        "func": "return msg = {topic: \"SELECT timer_id, strftime('%H',min(time)) as hour, strftime('%M',min(time)) as minute, strftime('%S',min(time)) as second, strftime('%d',min(time)) as day, strftime('%m',min(time)) as month, strftime('%Y',min(time)) as year FROM timer WHERE alarm = 0;\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 460,
        "y": 500,
        "wires": [
            [
                "10629c5c.0f3314"
            ]
        ]
    },
    {
        "id": "10629c5c.0f3314",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 680,
        "y": 500,
        "wires": [
            [
                "791877e5.612e2"
            ]
        ]
    },
    {
        "id": "791877e5.612e2",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "check remaining time",
        "func": "if(msg.payload[0].timer_id == null) return msg = {notification: \"Keine aktiven Timer vorhanden.\"};\n\ncurrentDate = new Date();\ncurrentDate.setMilliseconds(0);\n\ntimerDate = new Date(msg.payload[0].year, (msg.payload[0].month - 1), msg.payload[0].day, (msg.payload[0].hour - 1), msg.payload[0].minute, msg.payload[0].second);\ntimerDate.setMilliseconds(0);\n\ndiffDate = new Date(timerDate - currentDate);\n\nif(msg.payload[0].hour == 1) hourStr = \" Stunde, \";\nelse hourStr = \" Stunden, \";\n\nif(msg.payload[0].minute == 1) minuteStr = \" Minute und \";\nelse minuteStr = \" Minuten und \";\n\nif(msg.payload[0].second == 1) secondStr = \" Sekunde.\";\nelse secondStr = \" Sekunden.\";\n\nreturn msg = {notification: \"Nächster Timer in \" + diffDate.getHours() + hourStr + diffDate.getMinutes() + minuteStr + diffDate.getSeconds() + secondStr};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;\nvar timerDate;\nvar diffDate;",
        "finalize": "",
        "x": 920,
        "y": 500,
        "wires": [
            [
                "83cc3c71.6a41d8"
            ]
        ]
    },
    {
        "id": "47f0f61a.e02eb8",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build select statement",
        "func": "currentDate = new Date();\nalarmDate = new Date();\n\ncurrentDate.setHours(currentDate.getHours());\n\nif( !msg.slots.alarm_hour )\n    msg.slots.alarm_hour = 0;\n    \nif( !msg.slots.alarm_minute )\n    msg.slots.alarm_minute = 0;\n\nalarmDate.setHours(msg.slots.alarm_hour);\nalarmDate.setMinutes(msg.slots.alarm_minute);\n\nif(alarmDate > currentDate) {\n    return msg = {  topic: \"SELECT timer_id, strftime('%H',time) as hour, strftime('%M',time) as minute, strftime('%S',time) as second, strftime('%d',time) as day, strftime('%m',time) as month, strftime('%Y',time) as year, alarm FROM timer WHERE time = datetime('\" + alarmDate.getFullYear() + \"-\" + ('0' + (alarmDate.getMonth() + 1)).slice(-2) + \"-\" + ('0' + alarmDate.getDate()).slice(-2) + \" \"+ ('0' + alarmDate.getHours()).slice(-2) + \":\" + ('0' + alarmDate.getMinutes()).slice(-2) + \"');\",\n                    date: alarmDate};\n} else {\n    alarmDate.setDate(alarmDate.getDate() + 1);\n    return msg = {  topic: \"SELECT timer_id, strftime('%H',time) as hour, strftime('%M',time) as minute, strftime('%S',time) as second, strftime('%d',time) as day, strftime('%m',time) as month, strftime('%Y',time) as year, alarm FROM timer WHERE time = datetime('\" + alarmDate.getFullYear() + \"-\" + ('0' + (alarmDate.getMonth() + 1)).slice(-2) + \"-\" + ('0' + alarmDate.getDate()).slice(-2) + \" \"+ ('0' + alarmDate.getHours()).slice(-2) + \":\" + ('0' + alarmDate.getMinutes()).slice(-2) + \"');\",\n                    date: alarmDate};\n}",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;\nvar alarmDate;",
        "finalize": "",
        "x": 460,
        "y": 420,
        "wires": [
            [
                "3c3e035d.7b8494"
            ]
        ]
    },
    {
        "id": "3c3e035d.7b8494",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 680,
        "y": 380,
        "wires": [
            [
                "de577fa1.a2eb1"
            ]
        ]
    },
    {
        "id": "de577fa1.a2eb1",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build insert statement",
        "func": "currentDate = new Date();\n\nif(msg.payload[0] != null) {\n    return msg = {  notification: \"Wecker für diese Uhrzeit ist bereits vorhanden.\"};\n    \n} else if(msg.date.getDate() == currentDate.getDate()) {\n    return msg = {  topic: \"INSERT INTO timer (time, alarm) VALUES (datetime('\" + msg.date.getFullYear() + \"-\" + ('0' + (msg.date.getMonth() + 1)).slice(-2) + \"-\" + ('0' + msg.date.getDate()).slice(-2) + \" \"+ ('0' + msg.date.getHours()).slice(-2) + \":\" + ('0' + msg.date.getMinutes()).slice(-2) + \"'), 1);\",\n                    notification: \"Wecker gestellt für heute um \" + msg.date.getHours() + \" Uhr \" + msg.date.getMinutes() + \".\"};\n                    \n} else {\n    return msg = {  topic: \"INSERT INTO timer (time, alarm) VALUES (datetime('\" + msg.date.getFullYear() + \"-\" + ('0' + (msg.date.getMonth() + 1)).slice(-2) + \"-\" + ('0' + msg.date.getDate()).slice(-2) + \" \"+ ('0' + msg.date.getHours()).slice(-2) + \":\" + ('0' + msg.date.getMinutes()).slice(-2) + \"'), 1);\",\n                    notification: \"Wecker gestellt für morgen um \" + msg.date.getHours() + \" Uhr \" + msg.date.getMinutes() + \".\"};\n}",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;",
        "finalize": "",
        "x": 920,
        "y": 440,
        "wires": [
            [
                "83cc3c71.6a41d8",
                "ab55003f.511db8"
            ]
        ]
    },
    {
        "id": "31a2c467.0e3444",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build select statement",
        "func": "currentDate = new Date();\nalarmDate = new Date();\n\ncurrentDate.setHours(currentDate.getHours());\n\nif( !msg.slots.alarm_hour )\n    msg.slots.alarm_hour = 0;\n    \nif( !msg.slots.alarm_minute )\n    msg.slots.alarm_minute = 0;\n\nalarmDate.setHours(msg.slots.alarm_hour);\nalarmDate.setMinutes(msg.slots.alarm_minute);\n\nif(alarmDate > currentDate) {\n    return msg = {  topic: \"SELECT timer_id, strftime('%H',time) as hour, strftime('%M',time) as minute, strftime('%S',time) as second, strftime('%d',time) as day, strftime('%m',time) as month, strftime('%Y',time) as year, alarm FROM timer WHERE time = datetime('\" + alarmDate.getFullYear() + \"-\" + ('0' + (alarmDate.getMonth() + 1)).slice(-2) + \"-\" + ('0' + alarmDate.getDate()).slice(-2) + \" \"+ ('0' + alarmDate.getHours()).slice(-2) + \":\" + ('0' + alarmDate.getMinutes()).slice(-2) + \"');\",\n                    date: alarmDate};\n} else {\n    alarmDate.setDate(alarmDate.getDate() + 1);\n    return msg = {  topic: \"SELECT timer_id, strftime('%H',time) as hour, strftime('%M',time) as minute, strftime('%S',time) as second, strftime('%d',time) as day, strftime('%m',time) as month, strftime('%Y',time) as year, alarm FROM timer WHERE time = datetime('\" + alarmDate.getFullYear() + \"-\" + ('0' + (alarmDate.getMonth() + 1)).slice(-2) + \"-\" + ('0' + alarmDate.getDate()).slice(-2) + \" \"+ ('0' + alarmDate.getHours()).slice(-2) + \":\" + ('0' + alarmDate.getMinutes()).slice(-2) + \"');\",\n                    date: alarmDate};\n}",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;\nvar alarmDate;",
        "finalize": "",
        "x": 460,
        "y": 540,
        "wires": [
            [
                "27319554.0d883a"
            ]
        ]
    },
    {
        "id": "27319554.0d883a",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 680,
        "y": 560,
        "wires": [
            [
                "ff9a4dc0.25c67"
            ]
        ]
    },
    {
        "id": "ff9a4dc0.25c67",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "build delete statement",
        "func": "currentDate = new Date();\n\nif(msg.payload[0] == null) {\n    return msg = {  notification: \"Es wurde kein Wecker für diese Uhrzeit gestellt.\"};\n    \n} else {\n    return msg = {  topic: \"DELETE FROM timer WHERE time = datetime('\" + msg.date.getFullYear() + \"-\" + ('0' + (msg.date.getMonth() + 1)).slice(-2) + \"-\" + ('0' + msg.date.getDate()).slice(-2) + \" \"+ ('0' + msg.date.getHours()).slice(-2) + \":\" + ('0' + msg.date.getMinutes()).slice(-2) + \"');\",\n                    notification: \"Wecker gelöscht.\"};\n}",
        "outputs": 1,
        "noerr": 0,
        "initialize": "var currentDate;",
        "finalize": "",
        "x": 920,
        "y": 560,
        "wires": [
            [
                "83cc3c71.6a41d8",
                "2cfd5c2b.8b212c"
            ]
        ]
    },
    {
        "id": "2cfd5c2b.8b212c",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 1180,
        "y": 560,
        "wires": [
            []
        ]
    },
    {
        "id": "ccf13712.ad0298",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 680,
        "y": 440,
        "wires": [
            [
                "83cc3c71.6a41d8"
            ]
        ]
    },
    {
        "id": "ab55003f.511db8",
        "type": "sqlite",
        "z": "d138947f.fd823",
        "mydb": "7ffb752e.52a1bc",
        "sqlquery": "msg.topic",
        "sql": "",
        "name": "send statement to db",
        "x": 960,
        "y": 340,
        "wires": [
            []
        ]
    },
    {
        "id": "334edb57.6301d4",
        "type": "websocket in",
        "z": "d138947f.fd823",
        "name": "rhasspy in",
        "server": "5999adec.e962a4",
        "client": "",
        "x": 100,
        "y": 540,
        "wires": [
            [
                "3f8c9b9e.d42ea4"
            ]
        ]
    },
    {
        "id": "66dc3ef9.0a7ce",
        "type": "http request",
        "z": "d138947f.fd823",
        "name": "TTS",
        "method": "POST",
        "ret": "txt",
        "paytoqs": "ignore",
        "url": "http://192.168.0.177:12101/api/text-to-speech",
        "tls": "",
        "persist": false,
        "proxy": "",
        "authType": "",
        "x": 1450,
        "y": 420,
        "wires": [
            []
        ]
    },
    {
        "id": "d7fab366.05313",
        "type": "change",
        "z": "d138947f.fd823",
        "name": "set notification as payload for TTS",
        "rules": [
            {
                "t": "set",
                "p": "payload",
                "pt": "msg",
                "to": "notification",
                "tot": "msg"
            }
        ],
        "action": "",
        "property": "",
        "from": "",
        "to": "",
        "reg": false,
        "x": 1260,
        "y": 480,
        "wires": [
            [
                "66dc3ef9.0a7ce"
            ]
        ]
    },
    {
        "id": "e2302041.5c8c6",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "timer done",
        "func": "\nreturn {payload: \"Teimer abgelaufen\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 1270,
        "y": 280,
        "wires": [
            [
                "66dc3ef9.0a7ce"
            ]
        ]
    },
    {
        "id": "d9f6eede.07ca",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "start radio alarm",
        "func": "return msg = {payload : \"load radiostations\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 1260,
        "y": 240,
        "wires": [
            [
                "6db5ca73.6e5fd4",
                "171b50f6.2ae5f7"
            ]
        ]
    },
    {
        "id": "171b50f6.2ae5f7",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "repeat",
        "func": "return msg = {payload : \"repeat 1\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 1430,
        "y": 220,
        "wires": [
            [
                "9a3f074.b6e6678",
                "6db5ca73.6e5fd4"
            ]
        ]
    },
    {
        "id": "9a3f074.b6e6678",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "on",
        "func": "return msg = {payload : \"play\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 1530,
        "y": 340,
        "wires": [
            [
                "6db5ca73.6e5fd4"
            ]
        ]
    },
    {
        "id": "6db5ca73.6e5fd4",
        "type": "mpd out",
        "z": "d138947f.fd823",
        "name": "",
        "topic": "",
        "server": "9a410553.e09e3",
        "x": 1620,
        "y": 520,
        "wires": [
            []
        ]
    },
    {
        "id": "2865faf1.28970e",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "stop radio alarm",
        "func": "return msg = {payload : \"stop\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 460,
        "y": 600,
        "wires": [
            [
                "fc3efd1b.251468",
                "6db5ca73.6e5fd4"
            ]
        ]
    },
    {
        "id": "fc3efd1b.251468",
        "type": "function",
        "z": "d138947f.fd823",
        "name": "clear",
        "func": "return msg = {payload : \"clear\"};",
        "outputs": 1,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "x": 1230,
        "y": 600,
        "wires": [
            [
                "6db5ca73.6e5fd4"
            ]
        ]
    },
    {
        "id": "7ffb752e.52a1bc",
        "type": "sqlitedb",
        "db": "/data/sqllite/timer.db",
        "mode": "RWC"
    },
    {
        "id": "5999adec.e962a4",
        "type": "websocket-listener",
        "path": "ws://192.168.0.177:12101/api/events/intent",
        "wholemsg": "true"
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


Congratulation you've implemented all skills covered in this guide. Read the evaluation regarding used technologies in this project [here](../evaluation/evluation-intro.html).