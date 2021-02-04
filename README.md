# Apollo

This project was started as part of [INTIA](https://dites.web.th-koeln.de/forschung/projekte/intia/) and aims to introduce social facilities and other public institutions to methods and technologies regarding disability and educational assistance. Goal of this project was to create a offline voice assistant using open source technologies and highlight possible usability  and limitations of used technologies.

Start by reading the documentation for this project [here](https://ip-team3.intia.de/).

Configuration files are available [here](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data).
- Docker files
	- [Rhasspy](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data/docker%20compose%20files/rhasspy)
	- [Node-RED](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data/docker%20compose%20files/node%20red)
	- [ZigBee2MQTT](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data/docker%20compose%20files/zigbee2mqtt)
	- [Rasa](https://github.com/th-koeln-intia/ip-sprachassistent-team3/tree/master/data/docker%20compose%20files/rasa%20(deprecated)) (deprecated)
- Config files 
- Documentation files

## Skills implemented in this project

- Light Control
- Current Time
- Weather Forecast
- Covid Information
- Wikipedia
- Radio Station
- Alarm & Timer

### Documentation
The documentation is created in form of GitHub pages following the official documentation:  
[installation guide](https://docs.github.com/en/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll)

To run the documentation locally Jekyll is required. Follow the official installation [guide](https://jekyllrb.com/docs/installation/) to install Jekyll for the appropriate OS. It is important to install the correct version to prevent potential problems with Github Pages. The officially supported version is listed [here](https://pages.github.com/versions/).  
The following command starts a local server, if Jekyll is installed with bundler:
```bash 
bundle exec jekyll serve
```
