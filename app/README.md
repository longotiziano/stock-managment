# app

Este directorio contiene el código principal de la aplicación, incluyendo acceso a la base de datos, integración con Kafka y utilidades de procesamiento de datos.

## Orden de Bibliotecas
Para mayor claridad mental y consistencia, las importaciones en este proyecto siguen este orden:
1. Módulos del proyecto (orden alfabético)
2. SQLAlchemy
3. Kafka
4. pandas

## Responsibilities
- Sirve como interfaz entre la base de datos y la lógica de la aplicación. 
- Provee separaciones limpias entre consultas a la base de datos, lógica de negocio y comunicación con Kafka.
- Ofrece utilidades reutilizables  