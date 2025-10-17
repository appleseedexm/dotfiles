#!/bin/bash

TEMP_WORKSPACE_NAME="temp-target-float"
WINDOWS=$(niri msg -j windows)
WORKSPACES=$(niri msg -j workspaces)
WINDOW_TO_FETCH=$(echo "$WINDOWS" | jq -r ".[] | select(.app_id == \"Proton Pass\") | .id" | xargs)
WINDOW_FLOATING=$(echo "$WINDOWS" | jq -r ".[] | select(.app_id == \"Proton Pass\") | .is_floating" | xargs)
WORKSPACE_FOCUSED_NAME=$(echo "$WORKSPACES" | jq -r ".[] | select(.is_focused == true) | .name")

if [[ $WINDOW_FLOATING == "true"  ]] ; then

    niri msg action move-window-to-workspace --window-id $WINDOW_TO_FETCH startup
    niri msg action move-window-to-tiling --id $WINDOW_TO_FETCH
    
else

    if [[ -z $WORKSPACE_FOCUSED_NAME ]] ; then
        niri msg action set-workspace-name $TEMP_WORKSPACE_NAME
    fi

    niri msg action move-window-to-floating --id $WINDOW_TO_FETCH
    niri msg action move-window-to-workspace --window-id $WINDOW_TO_FETCH "$WORKSPACE_FOCUSED_NAME"
    niri msg action move-floating-window --id $WINDOW_TO_FETCH -x 0 -y 0
    niri msg action set-window-width --id $WINDOW_TO_FETCH 400
    niri msg action set-window-height --id $WINDOW_TO_FETCH 250

    if [[ -z $WORKSPACE_FOCUSED_NAME ]] ; then
        niri msg action unset-workspace-name 
    fi

fi
