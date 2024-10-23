#!/bin/bash

DEFAULT_BROWSER="zen-browser"
PROFILE=""

PPPID=$(ps -p $PPID -o ppid=)
PPPCOMMAND=$(ps -o comm= $PPPID)

if [[ "$DEFAULT_BROWSER_PROFILE" == "work" ]]; then
    PROFILE="-P work"
fi

if [[ "$PPPCOMMAND" == "foot" ]]; then
    PROFILE="-P temp"
fi

$DEFAULT_BROWSER $PROFILE "$@"
