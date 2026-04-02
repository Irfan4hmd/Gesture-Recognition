#!/bin/bash
# Rolls back to the most recent configuration backup.
# Extremely useful when a bad config breaks the camera drivers or overloads the system.

BACKUP_DIR="/opt/gesture-hri/backups"
LATEST_BACKUP=$(ls -t $BACKUP_DIR/settings_*.yaml.bak 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "ERROR: No backups found in $BACKUP_DIR!"
    exit 1
fi

echo "Rolling back to $LATEST_BACKUP..."
cp $LATEST_BACKUP config/settings.yaml

echo "Restarting service..."
sudo systemctl restart gesture-hri.service

echo "Rollback complete. System restored to previous state."
