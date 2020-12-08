---
# This top area is to give jekyll informations about the page.
layout: default
nav_order: 1
---

# APOLLO

## Introduction

This project is being developed as part of [INTIA](https://dites.web.th-koeln.de/forschung/projekte/intia/) and aims to introduce clients of social work to new digital tools while also ensuring their privacy.
The following documentation provides a thorough guide on how to install a personal voice assistant locally using open source resources and thus serving as leverage for beginners who are just becoming familiar with such technology. It also intents to give an insight on key advantages and possible limitations of used technology, important criteria to be met and unexpected hardships during the process.
Part of the expected end results include the user being able to switch on/off a lamp, set an alarm/timer, play music and receive information about the weather forecast.

### Important Notice

We configure everything in German (language code: de).
You can find a list of supported languages [here](https://rhasspy.readthedocs.io/en/latest/#supported-languages
).

## Getting started

### Hardware

- Raspberry PI 3b
- 64GB SD Card or more is recommended
- CC2531 ZigBee-Stick
- ReSpeaker 4-Mic Array
- (Philips Hue White & Color Ambiance E27) ZigBee lightbulb

### We have utilized the following stack for our voice assistant

- Pocketsphinx for the wake word and Speech To Text
- Rasa NLU for Intent Recognition
- Nano TTS for Text To Speech
- Rhasspy for Dialogue Management

### Protocols

- MQTT
- ZigBee

### Others

- ZigBee2MQTT

[Click here for a little introduction to all these topics](./glossary.md)

### Installations

- [VS Code](https://code.visualstudio.com/download) (or any other IDE that supports Python and Docker)
  - Python Extension
  - Docker Extension

- [Docker](https://docs.docker.com/engine/install/debian/)

- [GitBash](https://git-scm.com/downloads)

## Choosing a Wake Word

A so-called “wakeword” or “hotword” is what is used for first activating a voice assistant, after which you can give your voice command. Rhasppy supports listening for a wakeword with several systems to choose from. We have used Pocketsphinx.

Not all wake phrases work equally well. Here are some citeria we followed when choosing ours.

### Not too long and not too short

The word should contain at least six phonemes or have something along the lines of “OK” or “Hey” before it to make it easier for the voice assistant to decide whether the wakeword was triggered on purpose. Of course, the wake phrase should not be too long either.

### Diverse Sounds

A variety of sounds means different phonemes which in turn means a more distinctive signature. It decreases the chances of false positives.

[Time to set up your Pi](./instructions.md).
