#!/bin/bash

# xdg-settings set default-web-browser default-browser.desktop

DEFAULT_BROWSER="qutebrowser"
DEFAULT_FLAGS="--target tab --untrusted-args"
PROFILE_WORK="-B $HOME/.local/share/qutebrowser-work"
PROFILE_DEFAULT=""
PROFILE=""

PPPID=$(ps -p $PPID -o ppid=)
PPPCOMMAND=$(ps -o comm= $PPPID)

if [[ "$DEFAULT_BROWSER_PROFILE" == "work" ]]; then
    PROFILE="$PROFILE_WORK"
fi

if [[ "$PPPCOMMAND" == "foot" ]]; then
    INSTANCE=$(printf "default\nwork\n" | fuzzel --dmenu)

    if [[ "$INSTANCE" == "work" ]]; then
        PROFILE="$PROFILE_WORK"
    fi

fi

$DEFAULT_BROWSER $PROFILE $DEFAULT_FLAGS "$@"
