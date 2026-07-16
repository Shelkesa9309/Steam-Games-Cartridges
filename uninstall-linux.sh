#!/bin/bash

set -e

echo "Uninstalling Steam Game Cartridge launcher..."

########################################
# Check root
########################################

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi


########################################
# Stop running services
########################################

echo "Stopping cartridge services..."

systemctl stop 'game-cartridge@*' 2>/dev/null || true


########################################
# Remove launcher helper
########################################

echo "Removing launcher helper..."

rm -f /usr/local/bin/cartridge-launcher-helper


########################################
# Remove systemd service
########################################

echo "Removing systemd service..."

rm -f /etc/systemd/system/game-cartridge@.service


########################################
# Remove udev rule
########################################

echo "Removing udev rule..."

rm -f /etc/udev/rules.d/99-game-cartridge.rules


########################################
# Reload services
########################################

echo "Reloading system services..."

systemctl daemon-reload
systemctl reset-failed

udevadm control --reload-rules
udevadm trigger


########################################
# Done
########################################

echo ""
echo "=========================================="
echo " Steam Game Cartridge removed"
echo "=========================================="
echo ""