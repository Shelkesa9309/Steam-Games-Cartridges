#!/bin/bash

set -e

DEVICE="$1"

echo "Game cartridge detected: $DEVICE"


# Wait for desktop automounter
MOUNT_POINT=""

for i in {1..60}; do

    MOUNT_POINT=$(findmnt -n -o TARGET "/dev/$DEVICE" 2>/dev/null || true)

    if [ -n "$MOUNT_POINT" ]; then
        break
    fi

    sleep 0.5

done


if [ -z "$MOUNT_POINT" ]; then
    echo "No mount point found for /dev/$DEVICE"
    exit 0
fi


echo "Mounted at: $MOUNT_POINT"


if [ -f "$MOUNT_POINT/launch.sh" ]; then

    echo "Launching cartridge..."

    chmod +x "$MOUNT_POINT/launch.sh"

    bash "$MOUNT_POINT/launch.sh"

else

    echo "No launch.sh found on cartridge"

fi