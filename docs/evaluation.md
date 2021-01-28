---
layout: default
title: Evaluation
nav_order: 2
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

# Evaluation

## Overall stack evaluation

| Description         |  Technology  | Compatibility | Accessability / Support | Quality of Documentation | Overall Performance | Reliabilty |
| :---                | :---         |     :----:    |          :---:          | :---:                    | :---:               | :---:      |
| Wakeword            | PocketSphinx |               |                         |                          |                     |            |
| Speech To Text      | PocketSphinx |               |                         |                          |                     |            |
| Text To Speech      | NanoTTS      |               |                         |                          |                     |            |
| Dialogue Management | Rhasspy      |               |                         |                          |                     |            |
| Intent Recognition  | Rasa NLU     |               |                         |                          |                     |            |
| Intent Recognition  | Fsticuffs    |               |                         |                          |                     |            |
| Intent Recognition  | FuzzyWuzzy   |               |                         |                          |                     |            |

<br/><br/>

### PocketSphinx

| Pros         | Cons         |
| :---:        | :---:        |
|              |              |

<br/><br/>

### NanoTTS

| Pros         | Cons         |
| :---:        | :---:        |
|              |              |

<br/><br/>

### Rhasspy

| Pros         | Cons         |
| :---:        | :---:        |
|              |              |

<br/><br/>

### Rasa NLU

| Pros         | Cons         |
| :---:        | :---:        |
|              |              |

<br/><br/>

### Fsticuffs

| Pros         | Cons         |
| :---:        | :---:        |
|              |              |  

<br/><br/>

### FuzzyWuzzy

| Pros                                                                                          | Cons       |
| :---                                                                                          | :---:      |
| No installation needed                                                                        | XYZ        |
| Runs internally on Rhasspy                                                                    | XYZ        |
| Training of models is faster<ul><li>takes only seconds to train over a 1000 intents</li></ul> | XYZ        |
|                                                                                               | XYZ        |


<!-- >
Argumente die für die Verwendung von Fuzzywuzzy als Intent Recognition sprechen:
- Keine Installation notwendig
o Fuzzywuzzy läuft rhasspyintern
o für Rasa wurde ein Rasa NLU Server benötigt
o Rasa NLU läuft nur in einer veralteten Version (1.10.20) auf der Raspberry
Architektur – aktuell ist Version 2.2.5
o 2 GB Speicherplatz wurden für diesen Server gebraucht
- Trainieren von Modellen geht schneller
o Trainieren dauert bei über 10000 Intents nur sekunden
o bei Rasa war das Trainieren von großen Datenmengen nicht möglich -> ist in einer
Exception geendet 


## Funktionale Vollständigkeit

## Erweiterbarkeit

## Robustheit

--->

## Conclusion
