---
layout: default
title: Rasa implementation & issues
nav_order: 1
has_toc: true
parent: Legacy content
---
<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Rasa on a Raspberry Pi

This page acts as the implementation guide for Rasa on a Raspberry Pi. Rasa is an open source machine learning framework to automate text- and voice-based conversations. Rasa does not run on the Raspberry Pi's processor architecture. A custom docker image is required to run Rasa on a Raspberry Pi. This image was created by Koen Vervloesem. Find the creators github page [here](https://github.com/koenvervloesem/rasa-docker-arm){:target="_blank"}.

## Important notice

It is not recommended to use Rasa together with Rhasspy for two Reasons: 
1. Koen Vervloesems Docker image only supports Rasa version up to 1.1.20 (latest Rasa version is 2.2.9). 
2. Intents processed by Rasa do not contain numeric values. Find more on this issue [here](legacy-rasa-implementation.html#issues){:target="_blank"}.

## Implementation

Rasa needs to be initialized once before using docker-compose to run the image inside a container.

```shell
cd /home/pi
mkdir rasa
cd rasa
mkdir bin
cd bin
docker run -it -v "$(pwd):/app" -p 5005:5005 koenvervloesem/rasa:latest init # run container once to initialize rasa
```

<img src="../img/rasa_confirm.png" style="max-width: 100%;"/>

After the docker the image has been pulled successfully hit ```enter``` to accept the directory option and then confirm model initialization by pressing ```y```.
After the model was trained decline speaking to your trained assistant by pressing ```n```. Move into Rasa's directory and create a docker-compose file.

```shell
cd /home/pi/rasa
nano docker-compose.yml
```
```conf
rasa:
    image: "koenvervloesem/rasa:latest" # name of the used unofficial image
    container_name: rasa
    restart: unless-stopped
    volumes:
        - "/home/pi/rasa/bin:/app"
        - "/home/pi/rhasspy/.config/rhasspy/profiles:/profiles"
    ports:
        - "5005:5005"
    command: run --enable-api --debug
```
Press CTRL + x followed by y and then hit enter to save all changes.
Start Rasa and grant yourself permission to edit Rasa's configuration files.

```shell
docker-compose up -d # starts the container
sudo chown -R pi /home/pi/rasa
```
If everything went well, try accessing ```ip-address:5005``` from your browser. If something went wrong, try adding ```-it``` instead of ```-d``` to your ```docker-compose up``` command to see the output.

## Attaching Rasa to Rhasspy

Before connecting Rhasspy and Rasa make sure to clear your ```sentence.ini``` file of intents including large data. Numeric values won't be available after intent recognition more an that [below](). The following intents covert in the skill implementation section have to be removed:

1. Light control (brightness cant be controlled because of numeric values not working correctly)
2. Weather fore cast (Rasa can not compile all cities (14000) training crashes)
3. Alarm and timer (numeric values are not handled correctly)

Create a rasa config file inside the Rhasspy profile directory.

```shell
/home/pi/rhasspy/.config/rhasspy/profiles/de
nano rasacfg.yaml
```
This is the default rasa configuration with german language setting.

```conf
language: de
pipeline:
  - name: WhitespaceTokenizer
  - name: RegexFeaturizer
  - name: LexicalSyntacticFeaturizer
  - name: CountVectorsFeaturizer
  - name: CountVectorsFeaturizer
    analyzer: "char_wb"
    min_ngram: 1
    max_ngram: 4
  - name: DIETClassifier
    epochs: 100
  - name: EntitySynonymMapper
  - name: ResponseSelector
    epochs: 100

# Configuration for Rasa Core.
# https://rasa.com/docs/rasa/core/policies/
policies:
  - name: MemoizationPolicy
  - name: TEDPolicy
    max_history: 5
    epochs: 100
  - name: MappingPolicy

```
Press CTRL + x followed by y and then hit enter to save all changes.

Access Rhasspy's web interface at ```<pi's-ip:12101/settings```, set ```Intent Recognition``` to ```RASA NLU``` and provided the following information for ```Server URL``` and ```YAML Config```:

<img src="../img/rasa_rhasspy_config.png" style="max-width: 50%;"/>

Press ```Train``` to test the connection between Rhasspy and Rasa and train a model containing your intents. 

# Issues 

Two major issues required switching to Fsticuffs for intent recognition.

1. Training intents relying on large slot slits took a lot of time and made the Raspberry Pi crash or run into a training exception. 
2. Number range slots containing numeric values were transmitted as words (10 -> ten).

Both issues could be traced back to Rasa components. Components make up Rasa's NLU pipeline and work sequentially to process user input into structured output. There are components for entity extraction, for intent classification, response selection, pre-processing, and more.

<img src="../img/rasa_component.png" style="max-width: 100%;"/>

## Big data sets

This issue was resolved by changing Rasa's config file to use light weighted pipelines. 

```conf
language: "de"

pipeline:
- name: "KeywordIntentClassifier"
  case_sensitive: False
- name: "WhitespaceTokenizer"  
- name: "CRFEntityExtractor"
```

This set of pipeline components consists of three parts:

1. IntentClassifier (responsible for Intent extraction)
2. WhitespaceTokenizer (responsible for putting whitespaces between words)
3. CRFEntityExtractor (responsible for identifying entities)

The default configuration includes Supervised Embeddings (pre-trained words). The advantage of using pre-trained word embeddings in your pipeline is that if you have a training example like: “I want to buy apples”, and Rasa is asked to predict the intent for “get pears”, your model already knows that the words “apples” and “pears” are very similar. Such functionality is not required for Rhasspy's intent processing. Removing Supervised Embeddings from Rasa's components reduced training times by 80% and lowered the Raspberry Pi's workload significantly.

## Numeric values

This issue was resolved by using [DucklingHTTPExtractor](https://rasa.com/docs/rasa/components#ducklinghttpextractor){:target="_blank"} for entity extraction. To use this component a running duckling server is required. Duckling does not support Raspberry Pi's processor architecture. After spending too much time trouble shooting this issue the decision was made to continue using Fisticuffs for intent recognition.


