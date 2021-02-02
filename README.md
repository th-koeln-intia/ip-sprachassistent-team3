# Apollo

This project is being developed as part of [INTIA](https://dites.web.th-koeln.de/forschung/projekte/intia/) and aims to introduce clients of social work to new digital tools while also ensuring their privacy.
The following documentation provides a thorough guide on how to install a personal voice assistant locally using open source resources and thus serving as leverage for beginners who are just becoming familiar with such technology. It also intents to give an insight on key advantages and possible limitations of used technology, important criteria to be met and unexpected hardships during the process.
Part of the expected end results include the user being able to switch on/off a lamp, set an alarm/timer, play music and receive information about the weather forecast.

You can find our extensive documentation [here](https://ip-team3.intia.de/).

# Short structure overview

 - The data folder contains all our docker-compose files, config files and more
 - The deprecated folder includes our data files for rasa which we ultimately did not use. The reason why can be found [here](https://ip-team3.intia.de/issues.html#rasa-does-not-run-on-arm).
 - The docs folder conatins all of our files for the [documentation](https://ip-team3.intia.de/).

# Direct links to config files

 - [Node-Red docker-compose file](https://github.com/th-koeln-intia/ip-sprachassistent-team3/blob/master/data/node-red/docker-compose.yml)
	 - [Node-Red flows](https://github.com/th-koeln-intia/ip-sprachassistent-team3/blob/master/data/node-red/data/flows.json)
 - [Rhasspy docker-compose file](https://github.com/th-koeln-intia/ip-sprachassistent-team3/blob/master/data/rhasspy/docker-compose.yml)
	 - [Rhasspy Slots](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data/rhasspy/.config/rhasspy/profiles/de/slots)
	 - [Rhasspy intents](https://github.com/th-koeln-intia/ip-sprachassistent-team3/blob/master/data/rhasspy/.config/rhasspy/profiles/de/sentences.ini)
 - [Zigbee2mqtt docker-compose file](https://github.com/th-koeln-intia/ip-sprachassistent-team3/blob/master/data/zigbee2mqtt/docker-compose.yml)
