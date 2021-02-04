---
layout: default
parent: Intro
grand_parent: Skills
title: Rhasspy intent
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

# Rhasspy intent implementation

Rhasspy categorizes voice commands by intent, these commands may contain slots (list of alternatives) or named entities, such as the color or name of a light. All voice commands are stored in an [ini file](https://docs.python.org/3/library/configparser.html){:target="_blank"} whose "sections" are intents and "values" are sentence templates. Check out Rhasspy's [docs page](https://rhasspy.readthedocs.io/en/latest/training/){:target="_blank"} for more information on intent structure. Your voice assistant will only listen to sentences stored inside the sentence ini file.

## Intent creation

With Rhasspy running, access Rhasspy's web interface sentences page at ```ip-address:12101/sentences```.

1. Add your intent 
```conf
[TestIntent] 
this is a test 
```
2. Press ```Save Sentences```
3. Press ```View``` and ```Confirm Guesses``` to confirm pronunciation for unknown words.

Speaking out the hot word followed by a sentence stored inside the sentence ini file, the voice assistant will recognize your intent.

## Slots

Large alternatives can become unwieldy quickly.For example, say you have a list of lamps:

```conf
lamps = ("kitchen lamp" | "bedroom lamp" | "bathroom lamp" | ...)
```
Rather than keeping this list in your ```sentence file```, you may put each lamp name on a separate line in a file named ```slots/lamps``` (no file extension) and reference it as ```$lamps```. Rhasspy automatically loads all files in the slots directory of your profile and makes them available as slots lists.

For the example above, the file ```slots/lamps``` should contain:

```conf
kitchen lamp
bedroom lamp
bathroom lamp
```

### Slot creation

With Rhasspy running, access Rhasspy's web interface sentences page at ```ip-address:12101/slots```.

1. Press ```New Slot```
2. Enter ```Slot name``` & press ```New Slot```
3. Enter slots into the slot area
4. Press ```Save Slot```

For slot deletion clear the slot are & press ```Save Slot``` followed by a page refresh.

[Continue with light control skill implementation](../skill-light-control.html)

