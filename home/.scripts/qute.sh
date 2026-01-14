while getopts "w" flag; do
    case "${flag}" in
        w) WORK=true ;;
    esac
done

IFS="|"

SHORTCUTS="duckduck|aursearch|archhelp|archpackages|youtubesearch|githubsearch|"
QUTE_DATA_DIR="$XDG_DATA_HOME/qutebrowser"
QUTE_CONFIG_DIR="$XDG_CONFIG_HOME/qutebrowser"
CUSTOM_PROFILE=""

if [[ $WORK == true ]]; then
    QUTE_DATA_DIR="$XDG_DATA_HOME/qutebrowser-work/data"
    QUTE_CONFIG_DIR="$XDG_DATA_HOME/qutebrowser-work/config"
    SHORTCUTS="shortcutsearch|shortcutticket|$SHORTCUTS"
    CUSTOM_PROFILE="work"
fi


[ -z "$QUTE_URL" ] && QUTE_URL='https://duckduckgo.com'

url=$(printf  "${SHORTCUTS//\|/\\n}%s" "$(sqlite3 -separator ' - ' "$QUTE_DATA_DIR/history.sqlite" 'select title, url from CompletionHistory order by last_atime desc' | cat "$QUTE_CONFIG_DIR/quickmarks" - )"  | fuzzel --log-level=info --dmenu -l 15 )
url=$(echo "$url" | sed -E 's/[^ ]+ +//g' | grep -E "https?:" || echo "$url")

[ -z "${url// }" ] && exit

if [[ "${IFS}${SHORTCUTS[*]}${IFS}" =~ "${IFS}${url}${IFS}" ]]; then
    target="$(fuzzel --dmenu -l 0 --prompt="$url > ")"
    [ -z "${target// }" ] && exit
    url="${url//duckduck} $target"
fi

unset IFS

QUTE_EXEC=$(env DEFAULT_BROWSER_PROFILE=$CUSTOM_PROFILE sh $HOME/.scripts/default-browser.sh -p)

$QUTE_EXEC "$url"
