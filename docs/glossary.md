---
layout : default
---

# Glossary

## MQTT

- bidirectional communication protocol designed for transferring messages
- uses a publish / subscribe model
- requires use of a central broker
- messages are published to a broker on a specific topic  
- standard ports: 1883, 8883 (secure)

## ZigBee

- communication protocol
- works in PAN
  - a way for devices to communicate with one another wirelessly
  - commonly used instead of WiFi in devices like lighting control, door locks etc.
  - no main transmitter but a series of such
  - for low-power short-distance communications
- in a zigbee network 3 types of devices:
  - router: enables communication between nodes, never sleeps
  - coordinator: special type of router, forms the network
  - end device: has one parent, coordinator or router

## Others

## ZigBee2MQTT

- enables control over zigbee devices via MQTT
  - maps zigbee messages to MQTT messages
    - is the coordinator (in our case CC2531 Zigbee USB stick) in the zigbee network
    - is the MQTT client in the MQTT network and is subscribed to a broker (in our case Hermes MQTT)
- for configurations: configuration.yaml

## Rhasspy

- open source voice assistant toolkit
- supports multiple languages
- works with speech and intent recognizer

### PocketSphinx

- continuous speech recognizer
- works on mobile devices and desktop
- dependant on Sphinxbase
- base for profile for German in Rhasspy

### Rasa NLU

- intent recognizer
- an open-source tool for extracting semantic information from a natural language input
- requires a list of messages with labelled intents and entities (training data)  
- identifies entities and classifies intents mainly by tagging the specific message or part of it based on training data

### Hermes MQTT

- MQTT adapter
- according to it and subscribed messages Rhasspy determines whether to record voice commands or not
