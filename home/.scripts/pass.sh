#!/bin/bash

VAULT=Personal
TIMER=5

while getopts "w" flag; do
    case "${flag}" in
        w) VAULT=Work ;;
    esac
done

function copy(){
    VALUE=$1
    TYPE=$2
    if [[ -n $VALUE ]]; then
        wl-copy $VALUE && notify-send "Proton" "$TYPE copied!" && sleep $TIMER && wl-copy --clear &
    else
        notify-send "Proton" "No $TYPE found!"
    fi
}

function warn(){
    TYPE=$1
    notify-send --urgency=critical --expire-time=3000 "Proton" "Could not find $TYPE"
}

TITLE=$(pass-cli item list --vault-name $VAULT --output json | jq -r ".items | .[] | .title" | fuzzel --dmenu)

if [ -n "$TITLE" ]; then

    # sleep 15 && wl-copy --clear &

    ENTRY=$(pass-cli item view "pass://$VAULT/$TITLE" --output json | jq -r ".item | .content | .content | .Login " )


    USERNAME=$(echo $ENTRY | jq -r ".username? | select(. != null) ")
    if [ -z $USERNAME ]; then
        USERNAME=$(echo $ENTRY | jq -r ".email? | select(. != null) ")
    fi

    if [ -n "$USERNAME" ]; then
        copy $USERNAME user
    else
        warn user
    fi

    PASSWORD=$(echo $ENTRY | jq -r ".password? | select(. != null) ")

    if [ -n "$PASSWORD" ]; then
        if [ -n "$USERNAME" ]; then
            sleep $TIMER
        fi
        copy $PASSWORD secret
    else
        warn secret
    fi

fi

