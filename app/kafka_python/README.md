# kafka_python

This directory contains Kafka producers and consumers that extract and insert logs into the database.

## IMPORTANT

- The `handle_db_errors` decorator works best when `r_id` is the first parameter. For that reason, every function that requires this parameter receives `r_id` first, even if the decorator is not applied.
- An r_id of 9999 means it’s not tied to any restaurant in particular, but is used as a generic placeholder.

## Logging Strategy
- **Critical errors** are logged in big, high-level functions, and using `@handle_db_errors`.  
- **Debug and info events** are logged in intermediate functions, such as `products_df_verifier`.  

## Responsibilities
- Define tables, columns, and relationships used in the application.  
- Serve as the interface between the database and the application logic.  
- Extract, transform, and insert log data into the database.