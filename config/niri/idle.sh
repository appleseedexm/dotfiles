#!/bin/sh
/usr/bin/swayidle -w timeout 601 'niri msg action power-off-monitors' timeout 600 'swaylock -f' before-sleep 'swaylock -f'
