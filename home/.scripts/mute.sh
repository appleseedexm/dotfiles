#!/bin/bash

# Change this line with the source's name from `wpctl status`
MICROPHONE_SOURCE_NAME="RØDE NT-USB+ Mono"
#MICROPHONE_SOURCE_NAME="Antlion Wireless Microphone Mono"
MICROPHONE_SOURCE_DEFAULT_VOLUME="0.75"

FORCE_MUTE=false
OUTPUT_MUTE_STATE=false
STARTUP=false

while getopts "mos" flag; do
    case "${flag}" in
        m) FORCE_MUTE=true ;;
        o) OUTPUT_MUTE_STATE=true ;;
        s) STARTUP=true ;;
    esac
done

get_volume_line() {
    echo "$( wpctl status | grep "$MICROPHONE_SOURCE_NAME" | grep -i vol )"
}

is_muted() {
    echo "$( get_volume_line | grep -c "MUTED" )"
}

waybar_sig(){
    pkill -RTMIN+2 waybar
}

toggle_mute() {
    wpctl set-mute $MICROPHONE_SOURCE_ID toggle
    # fixing wpctl not saving volumes anymore
    wpctl set-volume $MICROPHONE_SOURCE_ID $MICROPHONE_SOURCE_DEFAULT_VOLUME
    waybar_sig
}

dunst_notify() {
    if [ $(is_muted) -eq "1" ]; then
        DUNST_MESSAGE="Microphone muted"
    else
        DUNST_MESSAGE="Microphone unmuted"
    fi

    dunstify -a "Microphone" -u low Microphone "${DUNST_MESSAGE}" -t 1000
}

dunst_error() {
    dunstify -a "Microphone" -u critical Microphone "${DUNST_MESSAGE_MIC_NOT_FOUND}"
    exit 1
}

wait_for_wpctl() {
    safety=0
    sleep 2

    while [ $(get_volume_line | grep -c "vol") -eq "0" ]; do
        if [ $safety -gt 10 ]; then
            dunst_error
        fi

        ((safety++))
        sleep 1
    done
    
    if [ $(is_muted) -eq "0" ]; then
        toggle_mute
    fi

    sleep 5
    waybar_sig

}

MICROPHONE_SOURCE_ID=$(get_volume_line | grep -o -E '[0-9]+' | head -1)
VOLUME_LINES_COUNT=$(get_volume_line | grep -c vol)
DUNST_MESSAGE_MIC_NOT_FOUND="Source not found, unable to mute/unmute microphone."

main() {

    if [ $STARTUP = true ]; then
        wait_for_wpctl
        exit
    fi

    if [ $OUTPUT_MUTE_STATE = true ]; then
        echo $(is_muted)
        exit
    fi

    if [ $VOLUME_LINES_COUNT -eq "1" ]; then

        if [ $FORCE_MUTE = true ] && [ $(is_muted) -eq "0" ]; then
            toggle_mute
        fi

        if [ $FORCE_MUTE = false ]; then 
            toggle_mute
            dunst_notify
        fi

        exit
    fi

    dunst_error
}

main
