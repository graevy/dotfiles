#!/bin/sh
# systemd service, grabs weather for setWeather.sh

curl -s wttr.in | head -n 7 > ~/.weather.cache
