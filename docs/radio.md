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

Now to the fun part. You will need to make a list containing the URLs of the mp3 streams for the radio stations you want your VA to play from. It is imperative that these URLs lead to a player that starts by itself without requiring the user to press play or anything similar. We have used URLs from [this site](https://www.chip.de/artikel/Webradio-Live-Stream-Alle-Sender-im-ueberblick_139924359.html) under the MP3 Stream column. Of course, these are German radio stations so you will need to find ones for your preferred language.

You will need to create a file for those URLs.

```shell
sudo nano radiostations.m3u
```

The file ending is crucial since mpd will not be able to find the file otherwise. If you want to use our file, you can find it in our GitHub Repository.

You will need to reboot your Pi after adding the file with the URLs so that mpd can find the new radiostations file.

Last but not least, you will need to edit some thing in mpd's configuration file. First, change back into the home directory via ```cd ~```, then open the file with nano.

```shell
sudo nano /etc/mpd.conf
```

In here, you will need to edit the default file path to the playlist directory, so that it now points to where your own playlist directory lies. The line should look something like this.

```shell
playlist_directory  ./radio/playlists
```

Afterwards, you should have a functioning radio.

To test it from the command line, you can use mpc commands as followed. These are only the most basic ones to get you started.

```shell
mpc clear # to clear the database
mpc load radiostations # to load the file containing your URLs
mpc play # to start playing the radiostations in that file from the start
mpc stop # to stop the radio from playing
mpc status # to see the player's status, including what station and what song is currently playing
```

In order to control the mpd via voice command, you will need to install its respective [NodeRed node](https://flows.nodered.org/node/node-red-contrib-mpd). The rest should be familiar to you by now.

Music Player Daemon offers an array of functionalities and commands, but since we cannot go into depth about all of them, here is a link to their [documentation](https://www.musicpd.org/doc/html/protocol.html).

<!--- >
## Troubleshooting

If the player is correctly running, but no sound comes from your Pi, it is worth a shot to open your ```alsa.conf``` file and clarify the de

-->

## Complete flow

<!--- ![flowimage](../assets/flow_.png) -->

<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>
