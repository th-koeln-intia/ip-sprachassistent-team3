---
layout: default
title: Getting the weather report
nav_order: 4
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

# Getting the Weather report

We have chosen the [OpenWeather API](https://openweathermap.org/api) based on research done by fellow students working on as similar project but with a different stack. [Click here](https://ip-team4.intia.de/) to be forwarded to their documentation.

You will need to register on their [website](https://openweathermap.org/) for a free API key. They offer subscription-models for a wider range of functions if you are interested, but the free version is enough for us. They offer multiple versions of their APIs and the one we have chosen is the One Call API. Do not forget to install the OpenWeather Node in order to make calls to the API.

The only "downside" to this API is that it demands longitude and latitude coordinates as input instead of a city name. This is not exactly user friendly for a spoken command. In order to solve this, we employ another [API for Geocoding](https://developer.mapquest.com/). This API is responsible for converting the name of a given city from the voice command into its corresponding coordinates which can then be relayed to our Openweather API.

## Flow features

- The current temperature in a specific city, humidity and details regarding whether it is sunny or cloudy
- Time of sunset and sunrise
- The weather forecast for the next 7 days

## Complete flow

<!--- flowimage --->

Here is the complete JSON flow.
<details close markdown="block">
  <summary>
    JSON for complete flow.
  </summary>

<!--- JSON --->