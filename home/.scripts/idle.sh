CMD="swayidle"
CMD_EXEC="sh $XDG_CONFIG_HOME/niri/idle.sh"

OUTPUT_IDLE_RUN_STATE=false

while getopts "o" flag; do
    case "${flag}" in
        o) OUTPUT_IDLE_RUN_STATE=true ;;
    esac
done

is_not_running() {
    PROCESS_ID=$(pgrep "${CMD}")
    [ -z "$PROCESS_ID" ]
}


waybar_sig(){
    pkill -RTMIN+3 waybar
}

main() {
    if [ $OUTPUT_IDLE_RUN_STATE = true ]; then
        if is_not_running; then
            echo "0"
        else
            echo "1"
        fi
        exit
    fi

    if is_not_running; then
        ${CMD_EXEC} &>/dev/null & disown;
    else
        pkill "${CMD}"
    fi

    waybar_sig
}


main
