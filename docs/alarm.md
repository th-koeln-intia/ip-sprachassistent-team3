---
layout: default
title: Setting an alarm
nav_order: 2
parent: Custom Intents
---

<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Setting an alarm

One of the features we want our VA to have is for the user to be able to set any number of alarms that won't be discarded even if the VA is accidentally unplugged. We decided to use SQLite for this. After setting up your SQLite database, all you need to do is install the necessary [SQLite node](https://flows.nodered.org/node/node-red-node-sqlite) for NodeRed to connect to your database. You can find the flow we have used down below or in our GitHub repsitory.

## Intents

## Flow features

- Set multiple alarms

- Ask when the next alarm goes off

- Stop an alarm after it goes off

- Delete an alarm

- Play the radio when the alarm goes off

## Complete flow

<!--- flowimage --->

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

<!--- JSON --->