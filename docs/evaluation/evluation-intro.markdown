---
layout: default
title: Evaluation
nav_order: 5
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

This page covers the evaluation for this project's technology and over all usability of the voice assistant. The intent recognition was switched during the project. Find the evaluation for Rasa [here](../legacy-content/legacy-rasa-implementation.html){:target="_blank"}. Implementation of the upcoming technologies was uncomplicated, since Rhasspy comes with everything included.

# Voice assistant usability

Implementing the voice assistant from scratch required technical expertise and experience in debian derived environments. There are no limits when it comes to customization as long as required knowledge is present. The voice assistant itself can be considered a niche product. It can be used for certain use cases regarding social facilities and other public institutions. We would like to underline that the voice assistant is not a jack of all trades, but can be used efficiently when it comes to areas of interest.

# Technology evaluation


Criteria used for this evaluation:

- performance
- efficiency 
- consistency
- controllability 
- learnability

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

