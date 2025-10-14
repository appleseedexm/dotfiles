#!/bin/bash

WINDOWS=$(niri msg -j windows)
DP1_WORKSPACE=$(niri msg -j workspaces | jq | jq ".[] | select(.is_active == true and .output == \"DP-1\") | .idx")
DP2_WORKSPACE=$(niri msg -j workspaces | jq | jq ".[] | select(.is_active == true and .output == \"DP-2\") | .idx")
WORKSPACE_FOCUSED=$(niri msg -j workspaces | jq | jq ".[] | select(.is_focused == true) | .idx")
WINDOW_TO_FOCUS=$(echo "$WINDOWS" | jq -r 'map("\(.title) - \(.app_id) - \(.id)") | .[]' | tofi | awk -F- '{print $NF}')

if [[ -n "$WINDOW_TO_FOCUS" ]] ; then
    niri msg action focus-window --id $WINDOW_TO_FOCUS
    niri msg action move-window-to-workspace $WORKSPACE_FOCUSED
    niri msg action focus-workspace $DP1_WORKSPACE
    niri msg action focus-workspace $DP2_WORKSPACE
    niri msg action focus-workspace $WORKSPACE_FOCUSED
fi
