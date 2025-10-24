#!/bin/bash
/usr/bin/swayidle -w \
    timeout 305 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
    timeout 300 'sh $HOME/.scripts/mute.sh -s' \
    timeout 300 'swaylock -f' \
    before-sleep 'swaylock -f'
