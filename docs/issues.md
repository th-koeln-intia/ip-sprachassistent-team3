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
