#!/bin/bash

set -e

TRUST_DIR="$HOME/.config/steam-games-cartridges"
TRUST_FILE="$TRUST_DIR/trusted_scripts.sha256"

mkdir -p "$TRUST_DIR"

echo "Scanning for script on Cartridge..."
echo ""

FOUND=0

# Scan mounted filesystems
while read -r DEVICE MOUNTPOINT; do

    # Skip empty mount points
    [ -z "$MOUNTPOINT" ] && continue

    SCRIPT="$MOUNTPOINT/launch.sh"

    if [ -f "$SCRIPT" ]; then

        FOUND=1

        echo "Found launch.sh"
        echo "Drive:  $DEVICE"
        echo "Path:   $SCRIPT"
        echo ""

        read -r -p "Do you want to add this script to trusted scripts? (Y/n): " CONFIRM

        # Default yes
        CONFIRM=${CONFIRM:-Y}

        case "$CONFIRM" in
            y|Y|yes|YES)

                HASH=$(sha256sum "$SCRIPT" | awk '{print $1}')

                echo "$HASH" >> "$TRUST_FILE"

                echo "Added to trusted scripts."
                echo "SHA256:"
                echo "$HASH"
                echo ""

                ;;

            *)
                echo "Skipped."
                echo ""
                ;;
        esac

    fi

done < <(findmnt -rn -o SOURCE,TARGET)


if [ "$FOUND" -eq 0 ]; then
    echo "No cartridges with launch.sh found."
fi


echo ""
echo "Trusted scripts database:"
echo "$TRUST_FILE"