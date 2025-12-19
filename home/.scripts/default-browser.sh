#!/bin/bash

# xdg-settings set default-web-browser default-browser.desktop

while getopts "p" flag; do
    case "${flag}" in
        p) path_only=true ;;
    esac
done

DEFAULT_BROWSER="qutebrowser"
DEFAULT_FLAGS="--target tab --untrusted-args"
PROFILE_WORK="-B $XDG_DATA_HOME/qutebrowser-work -C $XDG_DATA_HOME/qutebrowser-work/config/load-configs.py"
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

if [[ $path_only == true ]]; then
    echo "$DEFAULT_BROWSER $PROFILE $DEFAULT_FLAGS"
    exit
fi

$DEFAULT_BROWSER $PROFILE $DEFAULT_FLAGS "$@"
