---
layout: default
parent: Evaluation
title: Rhasspy stack
nav_order: 1
---
# Technology stack evaluation

This page covers the evaluation for this project's technology stack. The intent recognition was switched during the project. Find the evaluation for Rasa [here](../legacy-content/legacy-rasa-implementation.html){:target="_blank"}. Implementation of the upcoming technologies was uncomplicated, since Rhasspy comes with everything included.

## Wake Word: Pocketsphinx

Pocketsphinx's wake word performance was rated poorly. Not only does it trigger randomly, it is also not customizable by training. We started by using ```apollo``` as our keyword. ```apollo``` was chosen because it is very similar to ```alexa```. Using ```apollo``` as hot word was not bearable. The hot word was changed to ```hey apollo``` in later stages of this project. This increased the reliability of Pocketsphinx but not enough for a recommendation from our side.

Our recommendations for choosing a hot word:

1. avoid short single-word phrases
2. avoid long phrases
3. choose words with diverse sounds

## Speech to Text: Pocketsphinx

Pocketsphinx's speech to text performance in combination with ReSpeaker's 4-Mic Array received a good rating from us. Almost all spoken intens were recognized by Pocketsphinx. It was easy to add unknown words to its dictionary using Rhasspy's web interface. German language was handled surprisingly well and vowel mutations (ä ö ü) were no problem for Pocketsphinx.

## Intent Recognition: Fsticuffs

Fsticuffs was chosen to replace Rasa in later stages of this project. Find reason for Rasa's replacement [here](/legacy-content/legacy-rasa-implementation.html#issues){:target="_blank"}. Fisticuffs ability to handle intent recognition received a good rating from our site. There is not much too say about Fisticuffs. It does what it is supposed to do. One thing left mentioning is the tremendous increase of training speed after switching from Rasa to Fsticuffs.  

## Text to Speech: NanoTTS

NanoTTS text to speech ability was rated extremely bad. Simple sentences were pronounced in a robotic voice. The over all pronunciation of text was unpleasant. We would not recommend using NanoTTS for text to speech transcription.

## Dialogue Management: Rhasspy

Rhasspy's dialogue management received a good rating. Not a single instance was recorded where Rhasspy's dialogue management caused problems regarding MQTT connection to other services.
