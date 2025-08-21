#!/bin/bash
set -e

DB_NAME="restaurants_db"
USER="postgres"
HOST="db"
DATE=$(date +%Y%m%d_%H%M%S)
DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$DIR/${DB_NAME}_$DATE.backup"

CONTAINER="stock_managment-db-1"

docker exec $CONTAINER pg_dump -U $USER -F c -b -v -f /tmp/$DB_NAME_$DATE.backup $DB_NAME
docker cp $CONTAINER:/tmp/$DB_NAME_$DATE.backup "$FILE"
docker exec $CONTAINER rm /tmp/$DB_NAME_$DATE.backup
