# Verifiers

This module handles all validation logic.

## Responsibilities
- Ensure data consistency and correctness before it reaches the database.
- Validate stock availability, entity existence, and negative amounts.
- Handle both DataFrame-based and single-entry validation.

## Structure
- Base verifiers with common validation methods.
- Entity-specific verifiers (e.g., raw materials, products).
