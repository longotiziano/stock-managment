# Repositories

This module encapsulates database access logic and CSV managment.
Repositories isolate direct SQLAlchemy queries, providing a clean interface to read, update, or delete data. They also create different types of CSV files for testing, monitoring, and simulating a production environment.

## Responsibilities
- Query the database using SQLAlchemy.
- Provide reusable data access methods for each entity.
- Keep controller and verifier layers decoupled from raw queries.
- Create CSV files that simulate a production environment
