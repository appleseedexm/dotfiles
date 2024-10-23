#!/bin/bash

# Change this line with the source's name from `wpctl status`
MICROPHONE_SOURCE_NAME="RØDE NT-USB+"
MICROPHONE_SOURCE_DEFAULT_VOLUME="0.75"

FORCE_MUTE=false
OUTPUT_MUTE_STATE=false

while getopts "mo" flag; do
    case "${flag}" in
        m) FORCE_MUTE=true ;;
        o) OUTPUT_MUTE_STATE=true ;;
    esac
done

get_volume_line() {
    wpctl status | grep "$MICROPHONE_SOURCE_NAME" | grep -i vol 
}

is_muted() {
      get_volume_line | grep -c "MUTED"
}

toggle_mute() {
    wpctl set-mute $MICROPHONE_SOURCE_ID toggle
    # fixing wpctl not saving volumes anymore
    wpctl set-volume $MICROPHONE_SOURCE_ID $MICROPHONE_SOURCE_DEFAULT_VOLUME
}

dunst_notify() {
    if [ $(is_muted) -eq "1" ]; then
        DUNST_MESSAGE="Microphone muted"
    else
        DUNST_MESSAGE="Microphone unmuted"
    fi

    dunstify -a "Microphone" -u low Microphone "${DUNST_MESSAGE}" -t 1000
}

MICROPHONE_SOURCE_ID=$(get_volume_line | grep -o -E '[0-9]+' | head -1)
VOLUME_LINES_COUNT=$(get_volume_line | grep -c vol)
DUNST_MESSAGE_MIC_NOT_FOUND="Source not found, unable to mute/unmute microphone."

main() {

    if [ $VOLUME_LINES_COUNT -eq "1" ]; then
        
        if [ $OUTPUT_MUTE_STATE = true ]; then
            echo $(is_muted)
            exit
        fi

        if [ $FORCE_MUTE = true ] && [ $(is_muted) -eq "0" ]; then
            toggle_mute
        fi

        if [ $FORCE_MUTE = false ]; then 
            toggle_mute
            dunst_notify
        fi

        pkill -RTMIN+2 waybar

        exit
    fi

    dunstify -a "Microphone" -u critical Microphone "${DUNST_MESSAGE_MIC_NOT_FOUND}"
}

main
