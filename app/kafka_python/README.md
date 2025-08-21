# kafka_python

Este directorio contiene productores y consumidores de Kafka que extraen e insertan logs en la base de datos.

## IMPORTANTE

- El decorador `handle_db_errors` funciona mejor cuando `r_id` es el primer parámetro. Por esta razón, cada función que requiere este parámetro recibe `r_id` primero, es decir, como primer argumento.
- Un r_id de -9999 representa una ID que no está atada a ningún restaurante en particular, utilizándola de manera genérica.
