#!/bin/bash

VAULT=Personal
TIMER=5
TIMER_PLUS_1=6
USER=false

while getopts "uw" flag; do
    case "${flag}" in
        u) USER=true ;;
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

function get_info(){
    INFO=$(pass-cli info --output json 2>/dev/null)
}

function get_items(){
    ITEMS=$(pass-cli item list --vault-name $VAULT --output json 2>/dev/null)
}

if ! get_info ; then
    USER="$(fuzzel --dmenu -l 0 --prompt="%email ")"
    export PROTON_PASS_PASSWORD="$(fuzzel --dmenu -l 0 --prompt="%pass " --password)"
    export PROTON_PASS_EXTRA_PASSWORD="$(fuzzel --dmenu -l 0 --prompt="%extra " --password)"
    if ! pass-cli login --interactive $USER ; then
        notify-send --urgency=critical --expire-time=3000 "Proton" "Login unsuccessful!"
        exit 1
    fi
fi

if ! get_items ; then
    s="$(fuzzel --dmenu -l 0 --prompt="% " --password)"
    expect <<EOF
        spawn pass-cli session unlock
        expect -re "Enter lock code:"
        send "$s\r"
        expect eof
EOF
    get_items
fi

TITLE=$(echo $ITEMS | jq -r ".items | .[] | .title" | fuzzel --dmenu)

if [ -n "$TITLE" ]; then

    # sleep 15 && wl-copy --clear &

    ENTRY=$(pass-cli item view "pass://$VAULT/$TITLE" --output json | jq -r ".item | .content | .content | .Login " )

    if [ $USER = true ]; then
        USERNAME=$(echo $ENTRY | jq -r ".username? | select(. != null) ")
        if [ -z $USERNAME ]; then
            USERNAME=$(echo $ENTRY | jq -r ".email? | select(. != null) ")
        fi

        if [ -n "$USERNAME" ]; then
            copy $USERNAME user
        else
            warn user
        fi
    fi

    PASSWORD=$(echo $ENTRY | jq -r ".password? | select(. != null) ")
    if [ -n "$PASSWORD" ]; then
        if [ -n "$USERNAME" ]; then
            sleep $TIMER_PLUS_1
        fi
        copy $PASSWORD secret
    else
        warn secret
    fi

fi

