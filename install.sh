#!/bin/bash

CONFIG_PATH=$HOME/.config

source_files=(
    "dunst/dunstrc"
    "foot/foot.ini"
    "yofi/yofi.config"
    "tmux/.tmux.conf"
    "zsh/.zshrc"
)

dest_files=(
    "$CONFIG_PATH/dunst/dunstrc"
    "$CONFIG_PATH/foot/foot.ini"
    "$CONFIG_PATH/yofi/yofi.config"
    "$HOME/.tmux.conf"
    "$HOME/.zshrc"
)

backups_created=()

for ((i=0;i<${#source_files[@]};i++)) do

    echo "Linking ${source_files[i]} to ${dest_files[i]}"
    
    if [  -L ${dest_files[i]} ]; then
        echo "Is already a link, no action: ${dest_files[i]}"
    else
        ln -bs ${source_files[i]} ${dest_files[i]}
    fi

    backup_path=${dest_files[i]}~
    if [[ -f ${backup_path} || -L ${backup_path} ]]; then
        backups_created+=($backup_path)
    fi
done

echo "Backups existing:"
for backup in ${backups_created[@]}; do
    echo $backup
done


