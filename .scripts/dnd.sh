#!/bin/bash

CURRENT_PAUSE_LEVEL=$(dunstctl get-pause-level)

if [ $CURRENT_PAUSE_LEVEL -eq "0" ]; then
    dunstctl close-all
    dunstctl set-paused true
    pkill -RTMIN+1 waybar
else
    dunstctl set-paused false
    pkill -RTMIN+1 waybar
    dunstify -a "Notifications" -u low Notifications "Notifications LIVE" -t  2000
    sleep 4
    dunstctl close-all 
fi

