# app

This directory contains the main application code, including database access, Kafka integration, and data processing utilities.

## Libraries Order
For mental clarity and consistency, imports in this project follow this order:
1. Project modules (alphabetical order)
2. SQLAlchemy
3. Kafka
4. Pandas
5. Standard libraries (datetime, typing.Literal, json, os, etc.)

## Responsibilities
- Serve as the interface between the database and application logic.  
- Provide a clean separation between raw queries, business logic, and Kafka communication.  
- Offer reusable utilities for serialization, deserialization, and UTF-8 encoding/decoding.  
- Maintain a structured logging strategy across different layers of the application.