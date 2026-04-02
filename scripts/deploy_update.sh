#!/bin/bash
# Safely deploys new code/config by backing up current state first.
# Simulates a basic CI/CD deployment step on the edge device.

set -e

BACKUP_DIR="/opt/gesture-hri/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

echo "Backing up current configuration..."
cp config/settings.yaml $BACKUP_DIR/settings_$TIMESTAMP.yaml.bak

echo "Pulling latest changes from Git..."
git pull origin main

echo "Restarting service to apply changes..."
sudo systemctl restart gesture-hri.service

echo "Deployment complete. If issues occur, run scripts/rollback_config.sh"
