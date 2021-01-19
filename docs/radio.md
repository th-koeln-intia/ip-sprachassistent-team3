---
layout: default
title: Listening to the radio
nav_order: 6
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

# Listening to the radio

One of the tasks we want our VA to complete is to play the radio whenever the user gives the needed command. We have selected the Music Player Daemon (mpd) as our server to play our selected web radio stations from. Unfortunately, we did not manage to get mpd to play sound in a Docker container, so you will install mpd locally on the Pi.

First, you will create a new directory called radio in the Pi's home directory.

```shell
mkdir radio
```

After changing into this new directory via ```cd radio```, you will need to install mpd on your Pi. You will also install mpc, a client that can drive mpd and is useful for testing mpd from the command line.

```shell
sudo apt-get -y install mpd mpc
```

Next, still in the radio directory, you will create another directory called playlists. This will hold the file containing our webradio stations but more about that later.

```shell
mkdir playlists
```

Change into this new directory via ```cd playlists```.

Now to the fun part. You will need to make a list containing the URLs of the mp3 streams for the radio stations you want your VA to play from.
