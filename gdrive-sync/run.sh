#!/bin/bash

CONFIG_PATH=/data/options.json

# CLIENT_ID=$(jq --raw-output ".client_id" $CONFIG_PATH)
# CLIENT_SECRET=$(jq --raw-output ".client_secret" $CONFIG_PATH)
FOLDER=$(jq --raw-output ".folder" $CONFIG_PATH)
FOLDER_TO_CHANGE="/share/camera/"
REMOTE_FOLDER="gdrive:Lucas/private/home/camera"

print() {
   echo $(date -u) "[Info]  $1"
}

if [ -z "$FOLDER" ]; then
    FOLDER="/"
fi

print "Install rclone ..."

print `curl https://rclone.org/install.sh | sudo bash`

print "Create rclone dir .."
print `mkdir -p ~/.config/rclone `

print "Copy config .."
print `cp /config/rclone.conf ~/.config/rclone/rclone.conf `

print `mkdir -p $FOLDER_TO_CHANGE `

inotifywait -m -r -e create --format '%w%f' "${FOLDER_TO_CHANGE}" | while read NEWFILE
do
  if ! [ -d "$NEWFILE" ]; then
    FILE=$(basename "${NEWFILE}")
    PATH=$(dirname "${NEWFILE}")
    NEW_REMOTE_PATH="${PATH/${FOLDER_TO_CHANGE}/}"

    print "New file is detected $NEWFILE"
    print "Uploading \"$NEWFILE\" to \"$REMOTE_FOLDER/$NEW_REMOTE_PATH\""
    print `rclone copy "$NEWFILE" "$REMOTE_FOLDER/$NEW_REMOTE_PATH" -P `
    print "Copy done"
    print "Generate link \"$REMOTE_FOLDER$NEW_REMOTE_PATH$FILE\""
    print `rclone link "$REMOTE_FOLDER$NEW_REMOTE_PATH$FILE"`


    print "Delete \"$NEWFILE\""
    sudo rm -rf $NEWFILE*

    [ -z "`find $FOLDER_TO_CHANGE-type f`" ] && rm -rf $FOLDER_TO_CHANGE*
    print "Done"
  fi
done
