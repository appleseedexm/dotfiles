

CMD="hypridle"

is_not_running() {
    PROCESS_ID=$(pgrep "${CMD}")
    [ -z "$PROCESS_ID" ]
}

if is_not_running; then
    "${CMD}" &>/dev/null & disown;
else
    pkill "${CMD}"
fi

