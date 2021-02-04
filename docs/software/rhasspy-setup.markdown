---
layout: default
parent: Manual setup
grand_parent: Software
title: Rhasspy configuration
nav_order: 2
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

# Rhasspy configuration

## Rhasspy technology stack

Find below the technology stack used for the upcoming Rhasspy configuration. One of the goals for this project was to evaluate usability of said technology stack. Evaluation results can be found [here](/evaluation/evluation-intro.html){:target="_blank"}.

- Wake Word: Pocketsphinx
- Speech to Text: Pocketsphinx
- Intent Recognition: <span style="color:red">Rasa NLU *</span> - <span style="color:green">Fsticuffs</span>
- Text to Speech: NanoTTS
- Dialogue Management: Rhasspy 

### Rasa natural-language understanding <span style="color:red">*</span>

Rasa NLU was intended to be used in this project. Switching to Fsticuffs was necessary because of [various documented reasons](../legacy-content/legacy-rasa-implementation.html#issues){:target="_blank"}. Fsticuffs uses the rhasspy-nlu library and does not require additional configuration. If you are interested in Rasa NLU, check out our Rasa NLU page [here](../legacy-content/legacy-rasa-implementation.html){:target="_blank"}.

## Auto configuration

Desired configuration can be achieved more quickly by simply copying the profile settings into Rhasspy's configuration file. 

```shell
cd /home/pi/rhasspy/.config/rhasspy/profiles/de
nano profile.json
```
```shell
{
    "dialogue": {
        "system": "rhasspy"
    },
    "intent": {
        "system": "fsticuffs"
    },
    "microphone": {
        "pyaudio": {
            "device": "1"
        },
        "system": "pyaudio"
    },
    "sounds": {
        "aplay": {
            "device": "plughw:CARD=Headphones,DEV=0"
        },
        "system": "aplay"
    },
    "speech_to_text": {
        "system": "pocketsphinx"
    },
    "text_to_speech": {
        "system": "nanotts"
    },
    "wake": {
        "pocketsphinx": {
            "keyphrase": "hey apollo"
        },
        "system": "pocketsphinx"
    }
}
```
Press CTRL + x followed by y and then hit enter to save all changes.

Restart Rhasspy service. 

```shell
cd /home/pi/rhasspy
docker-compose down
docker-compose up -d 
```

After the restart access Rhasspy's web interface and follow instruction for downloading required Pocketsphinx profile files and confirm pronunciation for unknown words used in Rhasspy's example intents.

## Manual configuration

Access Rhasspy's web interface settings page at ```ip-address:12101/settings```.

### Audio recording

1. Select ```PyAudio```
2. Press ```Save settings```
3. Click on ```Audio Recording``` and press ```refresh```. Rhasspy is going to select your attached ReSpeaker 4-Mic Array. Otherwise a manual selection is required.
4. Press ```Save settings```

<img src="../img/AudioRecording.png"/>

### Audio playing

1. Select ```aplay```
2. Press ```Save Settings```
3. Click on ```Audio Playing``` and then choose ```Hardware device with all software conversions``` from ```Available Devices```.
4. Press ```Save Settings```

<img src="../img/AudioPlaying.png"/>

### Wake Word 

1. Select ```Pocketsphinx```
2. Press ```Save Settings```
3. Click on ```Wake Word``` and assign a desired wake word.
4. Press ```Save Settings```

<img src="../img/WakeWord.png"/>

### Speech to Text

1. Select ```Pocketsphinx```
2. Press ```Save Settings```
3. Click on ```Download``` to download required Pocketsphinx profile files
4. Click ```View``` and then ```Confirm Guesses``` to accept pronunciation for unknown words used in Rhasspy's example intents.
5. Press ```Restart``` in the top right corner

### Intent Recognition

1. Select ```Fsticuffs```
2. Press ```Save Settings```

### Text to Speech

1. Select ```NanoTTS```
2. Press ```Save Settings```

### Dialogue Management 

1. Select ```Rhasspy```
2. Press ```Save Settings```


[Continue with skill implementation](../skills/skill.html)
