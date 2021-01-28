---
layout : default
---

# Glossary

## Voice Assistant (VA)

A voice assistant is a digital assistant that uses voice recognition, speech synthesis, and natural language processing (NLP) to provide a service through a particular application.

## Docker

- similar to a VM in that it emulates an OS
- much more lightweight since it does not emulate the Kernel of the OS like a VM does
- Docker containers use the kernel of your host machine
- A container contains everything an application needs to run
- allows applications to be run in different environments without having to worry about things such as dependencies, since they are all in the container

For additional information on this topic, click [here](./sources.md#docker).

## MQTT

- bidirectional communication protocol designed for transferring messages
- uses a publish / subscribe model
- requires use of a central broker
- messages are published to a broker on a specific topic  
- standard ports: 1883, 8883 (secure)

For additional information on this topic, click [here](./sources.md#mqtt).

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

For additional information on this topic, click [here](./sources.md#zigbee).

## ZigBee2MQTT

- enables control over zigbee devices via MQTT
  - maps zigbee messages to MQTT messages
    - is the coordinator (in our case CC2531 Zigbee USB stick) in the zigbee network
    - is the MQTT client in the MQTT network and is subscribed to a broker (in our case Hermes MQTT)
- for configurations: configuration.yaml

For additional information on this topic, click [here](./sources.md#zigbee2mqtt).

## Rhasspy

- open source voice assistant toolkit
- supports multiple languages
- works with speech and intent recognizer

For additional information on this topic, click [here](./sources.md#rhasspy).

### PocketSphinx

- continuous speech recognizer
- works on mobile devices and desktop
- dependant on Sphinxbase
- base for profile for German in Rhasspy

For additional information on this topic, click [here](./sources.md#pocketsphinx).

### Rasa NLU

- intent recognizer
- an open-source tool for extracting semantic information from a natural language input
- requires a list of messages with labelled intents and entities (training data)  
- identifies entities and classifies intents mainly by tagging the specific message or part of it based on training data

For additional information on this topic, click [here](./sources.md#rasa).

### Hermes MQTT

- MQTT adapter
- according to it and subscribed messages Rhasspy determines whether to record voice commands or not

For additional information on this topic, click [here](./sources.md#hermes).

## NodeRed

- browser based flow editor
- used to connect hardware, interfaces and services used for IoT in a visual programming environment

For additional information on this topic, click [here](./sources.md#nodered).
