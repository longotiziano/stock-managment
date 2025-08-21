#!/bin/bash
DB_NAME="restaurants_db"
USER="postgres"
HOST="db"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../sql"
DATE=$(date +%Y%m%d_%H%M%S)
FILE="$BACKUP_DIR/${DB_NAME}_$DATE.backup"

mkdir -p $BACKUP_DIR

CONTAINER="stock_managment-db-1"

docker exec $CONTAINER pg_dump -U $USER -F c -b -v -f /tmp/backup_$DATE.backup $DB_NAME
docker cp $CONTAINER:/tmp/backup_$DATE.backup $FILE
docker exec $CONTAINER rm /tmp/backup_$DATE.backup

PGPASSWORD="andalaosa" pg_dump -h $HOST -U $USER -F c -b -v -f $FILE $DB_NAME

