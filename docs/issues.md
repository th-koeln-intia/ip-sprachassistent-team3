---
layout: default
title: Issues
nav_order: 1
parent: Usability
---


<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Issues

Here, we will compile and document the issues we have run into during the development of our voice assistant. 

## Rasa does not run on ARM

The official Rasa image cannot be run on the Pi's ARM based CPU. To get around this problem, we used an [unofficial image](https://github.com/koenvervloesem/rasa-docker-arm) compatible with ARM.

## Pocketsphinx does not train with number ranges

Since our language profile is set to German, naturally our voice assistant utilizes German training profiles. However, PocketSphinx does not seem to be able to train with ranges of numbers in its intents.

For instance, we wanted to use a range of numbers for the brightness settings of our light, so that the user would be able to just ask the voice assistant to set the brightness to any number inside our given range. Everytime we tried to train our VA to recognize such an intent, the training failed.

After some research, we have found the reason in Rhasspy's [official community forum](https://community.rhasspy.org/t/number-range-not-working/398). Apparently, the problem stems from using PocketSphinx as speech recognition in combination with the German language. The forum recommends using Kaldi instead.

We started working this problem from two ends. One half of our group tried to find a solution still using PocketSphinx while the other half switched over to using and testing Kaldi.

In the end, both approaches yielded positive results. It turns out that the number ranges problem referred to above is a result of the Rhasspy version we were using. It seems that Rhasspy 2.5.7 does not support that kind of use for PocketSphinx whereas Rhasspy 2.5.8 does. So a simple update should do the trick if you have run into the same problem.

At the same time, the use of number ranges with Kaldi as the speech to text engine has worked as well. Since our original task was to work with PocketSphinx and we have found a solution, we have decided to continue working with PocketSphinx.

For anyone interested in using Kaldi instead, here is a mini guide on what to change in your setup:

- First, you will need to delete your whole Rasa folder and then start Rasa in init mode again.

- You need to change your Rhasspy's settings for which you can use our profile.json below:

```shell
sudo nano /home/pi/rhasspy/.config/rhasspy/profiles/de/profile.json
```

Replace everything in the profile.json file with the following:

```shell
{
    "dialogue": {
        "system": "rhasspy"
    },
    "intent": {
        "rasa": {
            "config_yaml": "rasa_cfg.yaml",
            "url": "http://raspberrypi:5005/"
        },
        "system": "rasa"
    },
    "microphone": {
        "system": "pyaudio"
    },
    "sounds": {
        "system": "aplay"
    },
    "speech_to_text": {
        "system": "kaldi"
    },
    "text_to_speech": {
        "system": "nanotts"
    },
    "wake": {
        "pocketsphinx": {
            "keyphrase": "Apollo",
            "threshold": 1e-14
        },
        "system": "pocketsphinx"
    }
}
```

Press CTRL + X and then Y and hit enter to save the file.

- Now retrain everything and you should be good to go.

## The Raspberry Pi 3 is too weak for the amount of tasks we want it to perform

We worked on this project with a Pi 3b which only has 1 GB RAM and a CPU that doesn't have enough power to handle the amount of training data we are feeding it for all of the skills we want it to have. While it does train (although taking a lot of time), its response time averages around one to two minutes. Naturally, a VA should not take longer than a few seconds to respond. We therefore recommend using a newer model Raspberry Pi depending on the number of tasks and amount of data you want it to deal with. We realized this problem after training our Pi with all German city names so it could get their weather forecasts.

## With Rasa as intent recognition numbers are not presented as numerical values in the intent JSON

While we need them to be passed like this,

BILD

they currently look like this:

BILD

The Rhasspy Rasa NLU Hermes service is configured via start arguments. These start arguments are read from the supervisord.conf in the rhasspy profile directory.

BILD

Unfortunately, we were not able to achieve our wanted results by [adjusting them](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes). The child entity values was always set on unknown.

### We have tried the following fixes

#### Using the newest version of Rasa available (2.2.5)

- The Rasa we have running on our Pi is a custom patch/image of version 1.10.20 since Rasa is not available for ARM (see [Rasa does not run on ARM](https://ip-team3.intia.de/issues.html#rasa-does-not-run-on-arm))

- Unsuccessful

#### Changing of the Rasa pipelines

- Unsuccessful

#### Using another intent recognition

By using FuzzyWuzzy, we were able to achieve the wanted intent values.

BILD

The intent JSON contained the written version as well as the numerical value of the number. The question of whether a switch to another NLU in general was possible, remained.