#!/bin/bash

SOURCE_PATH=$PWD

BACKUPS_CREATED=()
MANUAL_INTERVENTION=()


function limiter(){
    echo "###################################################"
}

limiter

function link_folders(){

    SOURCE_DIR=$1
    TARGET_DIR=$2
   
    shopt -s dotglob
    for source_absolute_path in $SOURCE_DIR/*; do 


        BASE_NAME="$(basename $source_absolute_path)"
        TARGET_NAME="$TARGET_DIR/$BASE_NAME"

        echo "Processing $BASE_NAME"
        
        if [ -L ${TARGET_NAME} ]; then
            echo "Is already a link, no action: $TARGET_NAME"
        else
            # process files
            if [ -f ${source_absolute_path} ]; then
                echo "Linking file $source_absolute_path to $TARGET_NAME"
                ln -bs ${source_absolute_path} ${TARGET_NAME}
            #process dirs
            elif [ -d ${source_absolute_path} ]; then
                if ! [ -d ${TARGET_NAME} ]; then
                    # todo if dir exists needs backup
                    echo "Linking dir $source_absolute_path to $TARGET_NAME"
                    ln -s ${source_absolute_path} ${TARGET_NAME}
                else
                    echo "Directory $TARGET_NAME already exists"
                    MANUAL_INTERVENTION+=($TARGET_NAME)
                fi
            fi
        fi

        BACKUP_PATH=${TARGET_NAME}~
        if [[ -f ${BACKUP_PATH} || -L ${BACKUP_PATH} ]]; then
            BACKUPS_CREATED+=($BACKUP_PATH)
        fi

        limiter

        echo
        echo
    done

}

link_folders $SOURCE_PATH/config $XDG_CONFIG_HOME
link_folders $SOURCE_PATH/home $HOME

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
