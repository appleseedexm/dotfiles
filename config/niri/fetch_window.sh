#!/bin/bash

WINDOWS=$(niri msg -j windows)
WORKSPACES=$(niri msg -j workspaces)
DP1_WORKSPACE=$(echo "$WORKSPACES" | jq ".[] | select(.is_active == true and .output == \"DP-1\") | .idx")
DP2_WORKSPACE=$(echo "$WORKSPACES" | jq ".[] | select(.is_active == true and .output == \"DP-2\") | .idx")
WORKSPACE_FOCUSED_IDX=$(echo "$WORKSPACES" | jq ".[] | select(.is_focused == true) | .idx")
WORKSPACE_FOCUSED_DISPLAY=$(echo "$WORKSPACES" | jq -r ".[] | select(.is_focused == true) | .output")
WINDOW_TO_FETCH=$(echo "$WINDOWS" | jq -r 'map("\(.title) - \(.app_id) - \(.id)") | .[]' | tofi | awk -F- '{print $NF}' | xargs)

if [[ -n "$WINDOW_TO_FETCH" ]] ; then

    WINDOW_TO_FETCH_WORKSPACE=$(echo "$WINDOWS" | jq --argjson window_id $WINDOW_TO_FETCH '.[] | select(.id == $window_id) | .workspace_id')
    WINDOW_TO_FETCH_DISPLAY=$(echo "$WORKSPACES" | jq -r --argjson workspace_id $WINDOW_TO_FETCH_WORKSPACE '.[] | select(.id == $workspace_id) | .output')

    if [[ $WINDOW_TO_FETCH_DISPLAY == $WORKSPACE_FOCUSED_DISPLAY ]] ; then

        niri msg action focus-window --id $WINDOW_TO_FETCH
        niri msg action move-window-to-workspace $WORKSPACE_FOCUSED_IDX

    else

        niri msg action focus-window --id $WINDOW_TO_FETCH

        [[ "$WINDOW_TO_FETCH_DISPLAY" == "DP-1" ]] && \
            niri msg action move-window-to-monitor-left && \
            [[ "$WINDOW_TO_FETCH_WORKSPACE" != "$DP1_WORKSPACE" ]] && \
            niri msg action focus-monitor "DP-1" && \
            niri msg action focus-workspace $DP1_WORKSPACE

        [[ "$WINDOW_TO_FETCH_DISPLAY" == "DP-2" ]] && \
            niri msg action move-window-to-monitor-right && \
            [[ "$WINDOW_TO_FETCH_WORKSPACE" != "$DP2_WORKSPACE" ]] && \
            niri msg action focus-monitor "DP-2" && \
            niri msg action focus-workspace $DP2_WORKSPACE

        niri msg action focus-window --id $WINDOW_TO_FETCH

    fi

fi
