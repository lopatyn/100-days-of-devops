#!/bin/bash

# ==============================================================================
# Script Name:  auto_backup.sh
# Description:  Automates the backup of a source directory to a target folder.
# Why?          Manual backups are prone to human error and neglect. 
#               Automation via Cron ensures that critical data is 
#               consistently backed up without manual intervention.
# ==============================================================================

# CRITICAL: Always use absolute paths in Cron scripts!
SOURCE_DIR="/home/devops_service/data"
BACKUP_DIR="/home/devops_service/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

echo "Starting backup process at $(date)"

# Ensure backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Create the backup
# -c: create, -z: compress (gzip), -f: file
tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Error: Backup failed!"
    exit 1
fi

# Retention policy: remove backups older than 7 days
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -delete

echo "Cleanup of old backups completed."
echo "Backup process finished at $(date)"
