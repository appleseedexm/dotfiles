#!/bin/bash
/usr/bin/swayidle -w \
    timeout 300 'sh $XDG_CONFIG_HOME/argen/scripts/lock.sh' \
    timeout 300 'sh $HOME/.scripts/mute.sh -s' \
    timeout 305 'wlopm --off *' \
        resume 'wlopm --on *'
