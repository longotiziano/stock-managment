#!/bin/bash
set -e

psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'airflow'" | grep -q 1 || \
psql -U postgres -c "CREATE DATABASE airflow;"