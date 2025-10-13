#!/bin/sh
windows=$(niri msg -j windows)
niri msg action focus-window --id $(echo "$windows" | jq -r 'map("\(.title) - \(.app_id) - \(.id)") | .[]' | tofi | awk -F- '{print $NF}')
