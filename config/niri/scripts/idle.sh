#!/bin/bash
/usr/bin/swayidle -w \
    timeout 300 'sh $XDG_CONFIG_HOME/niri/scripts/lock.sh' \
    timeout 305 'sh $HOME/.scripts/mute.sh -s' \
    timeout 305 'niri msg action power-off-monitors' \
    before-sleep 'swaylock -f'
