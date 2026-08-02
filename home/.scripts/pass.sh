#!/bin/bash

VAULT=Personal

while getopts "w" flag; do
    case "${flag}" in
        w) VAULT=Work ;;
    esac
done

TITLE=$(pass-cli item list --vault-name $VAULT --output json | jq -r ".items | .[] | .title" | fuzzel --dmenu)

echo $TITLE

if [ -n "$TITLE" ]; then

    HASPASSWORD=$(pass-cli item view "pass://$VAULT/$TITLE/password")

    # ENTRY=$(pass-cli item view "pass://$VAULT/$TITLE" --output json | jq -r ".item | .content " )
    #
    # HASPASSWORD=$(echo $ENTRY | jq -r ".note? | select(. != null) ")
    #
    # echo $ENTRY | jq
    # echo +$HASPASSWORD\\

    if [[ -n $HASPASSWORD ]]; then

        wl-copy $HASPASSWORD && notify-send "Proton" "Copied!" && sleep 5 && wl-copy --clear &
    else

        notify-send "Proton" "No password found!"
    fi
fi


