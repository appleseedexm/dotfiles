#!/bin/bash

count_niri_sockets=$(ls /run/user/1000 | grep -ic "niri.wayland")

if [ $count_niri_sockets -ne 1 ]; then
    echo "Niri socket not found, counted $count_niri_sockets"
    exit 1

fi
socket=/run/user/1000/$(ls -1 /run/user/1000 | grep -i "niri.wayland" )

NIRI_SOCKET=$(echo $socket) niri msg action power-on-monitors

sunshine
