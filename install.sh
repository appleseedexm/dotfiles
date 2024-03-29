#!/bin/bash

CONFIG_PATH=$HOME/.config
SOURCE_PATH=$PWD

source_files=(
    "$SOURCE_PATH/dunst/dunstrc"
    "$SOURCE_PATH/foot/foot.ini"
    "$SOURCE_PATH/yofi/yofi.config"
    "$SOURCE_PATH/tmux/.tmux.conf"
    "$SOURCE_PATH/zsh/.zshrc"
)

dest_files=(
    "$CONFIG_PATH/dunst/dunstrc"
    "$CONFIG_PATH/foot/foot.ini"
    "$CONFIG_PATH/yofi/yofi.config"
    "$HOME/.tmux.conf"
    "$HOME/.zshrc"
)

BACKUPS_CREATED=()

for ((i=0;i<${#source_files[@]};i++)) do

    echo "Linking ${source_files[i]} to ${dest_files[i]}"
    
    if [  -L ${dest_files[i]} ]; then
        echo "Is already a link, no action: ${dest_files[i]}"
    else
        ln -bs ${source_files[i]} ${dest_files[i]}
    fi

    BACKUP_PATH=${dest_files[i]}~
    if [[ -f ${BACKUP_PATH} || -L ${BACKUP_PATH} ]]; then
        BACKUPS_CREATED+=($BACKUP_PATH)
    fi
done

echo "Backups existing:"
for backup in ${BACKUPS_CREATED[@]}; do
    echo $backup
done


