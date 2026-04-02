#!/bin/bash
# Monitors system health, camera availability, and service status.
# Designed to be run via cron every 5 minutes on the edge device.

LOG_FILE="/var/log/gesture_hri_health.log"
SERVICE="gesture-hri.service"

echo "[$(date)] Starting health check..." >> $LOG_FILE

# 1. Check Camera Availability
CAM_FAIL_COUNT_FILE="/tmp/camera_fail_count.txt"
MAX_FAILS=3

if [ ! -e /dev/video0 ]; then
    FAIL_COUNT=0
    if [ -f "$CAM_FAIL_COUNT_FILE" ]; then
        FAIL_COUNT=$(cat "$CAM_FAIL_COUNT_FILE")
    fi
    FAIL_COUNT=$((FAIL_COUNT+1))
    echo $FAIL_COUNT > "$CAM_FAIL_COUNT_FILE"
    if [ $FAIL_COUNT -le $MAX_FAILS ]; then
        echo "[$(date)] ERROR: Camera /dev/video0 not found! Attempting driver reload (attempt $FAIL_COUNT/$MAX_FAILS)..." >> $LOG_FILE
        sudo modprobe -r uvcvideo && sudo modprobe uvcvideo
        sleep 2
    else
        echo "[$(date)] CRITICAL: Camera /dev/video0 not found after $MAX_FAILS attempts. Please check hardware!" >> $LOG_FILE
    fi
else
    # Camera is available, reset fail counter
    rm -f "$CAM_FAIL_COUNT_FILE"
fi

# 2. Check Service Status
if ! systemctl is-active --quiet $SERVICE; then
    echo "[$(date)] WARNING: $SERVICE is down. Restarting..." >> $LOG_FILE
    sudo systemctl restart $SERVICE
else
    echo "[$(date)] OK: $SERVICE is running." >> $LOG_FILE
fi

# 3. Log Memory Usage (Edge devices have limited RAM)
FREE_MEM=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
echo "[$(date)] Memory Usage: $FREE_MEM" >> $LOG_FILE

# 4. Clean up old logs (Keep last 1000 lines)
tail -n 1000 $LOG_FILE > /tmp/health_tmp.log && mv /tmp/health_tmp.log $LOG_FILE
