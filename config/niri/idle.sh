#!/bin/sh
/usr/bin/swayidle -w \
    timeout 305 'niri msg action power-off-monitors' \
    timeout 300 'sh $HOME/.scripts/mute.sh -s' \
    timeout 300 'swaylock -f' \
    before-sleep 'swaylock -f'
