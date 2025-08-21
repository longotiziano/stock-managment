#!/bin/bash
set -e

export $(cat .env | xargs)

DIR="$(cd "$(dirname "$0")" && pwd)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="$DIR/${POSTGRES_DB}_$DATE.backup"

CONTAINER="stock_managment-db-1"

docker exec $CONTAINER pg_dump -U $POSTGRES_USER -F c -b -v -f /tmp/${POSTGRES_DB}_$DATE.backup $POSTGRES_DB
docker cp $CONTAINER:/tmp/${POSTGRES_DB}_$DATE.backup "$FILE"
docker exec $CONTAINER rm /tmp/${POSTGRES_DB}_$DATE.backup

echo "Backup generado en $FILE"
