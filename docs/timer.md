---
layout: default
title: Setting a timer
nav_order: 3
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

# Setting a timer

We want our VA to be able to set a timer for the time span given in the user's command. Since the Pi needs to be able to remember when a timer is supposed to go off even if the power goes out at some point, we decided to save our timers (as well as our [alarms](./alarm.md)) in a SQLite database.

After setting up your SQLite database (VERLINKUNG ZU TUTORIAL), all you need to do is install the necessary [SQLite node](https://flows.nodered.org/node/node-red-node-sqlite) for NodeRed to connect to your database. You can find the flow we have used down below or in our GitHub repsitory.

## Flow features

- Set multiple timers for up to 24 hours

- Ask when the next timer will go off

- Stop a timer after it goes off

<!-- Play music / a melody for when the timer goes off 
- Delete a timer -->

## Complete flow

<!--- flowimage --->

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

<!--- JSON --->