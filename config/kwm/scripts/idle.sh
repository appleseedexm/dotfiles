#!/bin/bash
/usr/bin/swayidle -w \
    timeout 300 'sh $XDG_CONFIG_HOME/kwm/scripts/lock.sh' \
    timeout 300 'sh $HOME/.scripts/mute.sh -s' \
    timeout 305 'wlopm --off DP-1' \
        resume 'wlopm --on DP-1' \
    timeout 305 'wlopm --off DP-2' \
        resume 'wlopm --on DP-2'
