#!/bin/bash

CONFIG_PATH=$HOME/.config
SOURCE_PATH=$PWD

BACKUPS_CREATED=()
MANUAL_INTERVENTION=()

#source_files=(
    #"$SOURCE_PATH/dunst/dunstrc"
    #"$SOURCE_PATH/foot/foot.ini"
    #"$SOURCE_PATH/yofi/yofi.config"
    #"$SOURCE_PATH/tmux/.tmux.conf"
    #"$SOURCE_PATH/zsh/.zshrc"
    #"$SOURCE_PATH/tofi"
    #"$SOURCE_PATH/waybar"
    #"$SOURCE_PATH/i3"
    #"$SOURCE_PATH/system/.inputrc"
    #"$SOURCE_PATH/tms"
    #"$SOURCE_PATH/alacritty"
    #"$SOURCE_PATH/.scripts"
#)

#dest_files=(
    #"$CONFIG_PATH/dunst/dunstrc"
    #"$CONFIG_PATH/foot/foot.ini"
    #"$CONFIG_PATH/yofi/yofi.config"
    #"$HOME/.tmux.conf"
    #"$HOME/.zshrc"
    #"$CONFIG_PATH/"
    #"$CONFIG_PATH/"
    #"$CONFIG_PATH/"
    #"$HOME/.inputrc"
    #"$CONFIG_PATH/"
    #"$CONFIG_PATH/"
    #"$HOME/"
#)

function limiter(){
    echo "###################################################"
}

limiter

#if [ ${#source_files[@]} -ne ${#dest_files[@]} ]; then
   #echo "Error: source and destination arrays must be the same length"
   #exit 1
#fi

CONFIG_SOURCE_PATH=$SOURCE_PATH/config

for absolute_path in $CONFIG_SOURCE_PATH/*;   do 


    FILE_NAME="$(basename $absolute_path)"
    TARGET_NAME="$CONFIG_PATH/$FILE_NAME"

    echo "Processing $FILE_NAME"
    
    if [ -L ${TARGET_NAME} ]; then
        echo "Is already a link, no action: $TARGET_NAME"
    else
        # process files
        if [ -f ${absolute_path} ]; then
            echo "Linking file $absolute_path to $TARGET_NAME"
            ln -bs ${absolute_path} ${TARGET_NAME}
        #process dirs
        elif [ -d ${absolute_path} ]; then
            if not [ -d ${TARGET_NAME} ]; then
                # todo if dir exists needs backup
                echo "Linking dir $absolute_path to $TARGET_NAME"
                ln -s ${absolute_path} ${TARGET_NAME}
            else
                echo "Directory $TARGET_NAME already exists"
                MANUAL_INTERVENTION+=($TARGET_NAME)
            fi
        fi
    fi

    BACKUP_PATH=${target_name}~
    if [[ -f ${BACKUP_PATH} || -L ${BACKUP_PATH} ]]; then
        BACKUPS_CREATED+=($BACKUP_PATH)
    fi

    limiter

    echo
    echo
done

#for ((i=0;i<${#source_files[@]};i++)) do

    #echo "Linking ${source_files[i]} to ${dest_files[i]}"
    
    #if [  -L ${dest_files[i]} ]; then
        #echo "Is already a link, no action: ${dest_files[i]}"
    #else
        #if [ -f ${source_files[i]} ]; then
            #mkdir -p $(dirname ${dest_files[i]})
            #ln -bs ${source_files[i]} ${dest_files[i]}
        #elif [ -d ${source_files[i]} ]; then
            ## todo if dir exists needs backup
            #ln -s ${source_files[i]} ${dest_files[i]}
        #fi
    #fi

    #BACKUP_PATH=${dest_files[i]}~
    #if [[ -f ${BACKUP_PATH} || -L ${BACKUP_PATH} ]]; then
        #BACKUPS_CREATED+=($BACKUP_PATH)
    #fi

    #echo
    #echo
    #echo
#done

limiter

echo "Backups existing:"
for backup in ${BACKUPS_CREATED[@]}; do
    echo $backup
done

limiter
echo ""
limiter

echo "Manual intervention required:"
for in in ${MANUAL_INTERVENTION[@]}; do
    echo $in
done
limiter
