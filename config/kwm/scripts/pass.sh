#!/bin/bash

CLOSE=false

while getopts "c" flag; do
    case "${flag}" in
        c) CLOSE=true ;;
    esac
done

eval_windows() {
    WINDOWS=$(niri msg -j windows)
    WINDOW_ID=$(echo "$WINDOWS" | jq -r ".[] | select(.app_id == \"Proton Pass\") | .id" | xargs)
}

close_window() {
    if [[ -n  $WINDOW_ID  ]] ; then
        niri msg action close-window --id $WINDOW_ID
    fi
}

if [ $CLOSE = true ]; then

    eval_windows
    close_window
    exit 0

fi

eval_windows

if [[ -z  $WINDOW_ID  ]] ; then

    proton-pass &>/dev/null

else

    close_window

fi
