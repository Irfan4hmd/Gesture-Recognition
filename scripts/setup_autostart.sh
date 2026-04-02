#!/bin/bash
# Automates the deployment of the Gesture-to-Speech systemd service
# Ensuring the system launches without manual input after a reboot.

set -e

SERVICE_NAME="gesture-hri.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"
CURRENT_DIR=$(pwd)

echo "Setting up $SERVICE_NAME..."

# Replace placeholder with actual path
sed "s|/opt/gesture-hri|$CURRENT_DIR|g" systemd/gesture-hri.service.template > /tmp/$SERVICE_NAME

sudo cp /tmp/$SERVICE_NAME $SERVICE_PATH
sudo chmod 644 $SERVICE_PATH

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling service to start on boot..."
sudo systemctl enable $SERVICE_NAME

echo "Starting service..."
sudo systemctl start $SERVICE_NAME

echo "Service setup complete. Check status with: systemctl status $SERVICE_NAME"
