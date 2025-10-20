#!/bin/bash
windows=$(niri msg -j windows)
niri msg action focus-window --id $(echo "$windows" | jq -r 'map("\(.title) - \(.app_id) - \(.id)") | .[]' | fuzzel --dmenu | awk -F- '{print $NF}')
