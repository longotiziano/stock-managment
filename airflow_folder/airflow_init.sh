#!/bin/bash

# Inicializar la base de datos de Airflow
airflow db init

# Crear usuario admin
airflow users create \
    --username admin \
    --firstname Air \
    --lastname Flow \
    --role Admin \
    --email admin@example.com \
    --password admin123