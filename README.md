**# Multi-Tenant E-Commerce / Order Management System**



**## Project Overview**



**This project is a multi-tenant e-commerce and order management system built as a database capstone project.**



**The system is designed to allow multiple businesses (tenants) to manage their products, customers, and orders securely using a shared PostgreSQL database.**



**## Main Objectives**



**The project demonstrates:**



**- Relational database design**

**- Multi-tenant architecture**

**- PostgreSQL Row-Level Security (RLS)**

**- Versioned database migrations**

**- Database indexes**

**- Query optimization**

**- Audit logging and triggers**

**- Redis integration**

**- Backup and recovery**

**- Database security**

**- Analytical queries**



**## Technology Stack**



**- PostgreSQL**

**- Flyway**

**- Redis**

**- SQL**

**- JSONB**

**- Git and GitHub**



**## Project Structure**



**```text**

**capstone/**

**├── analytics/**

**├── backups/**

**├── docs/**

**│   ├── diagrams/**

**│   └── requirements.md**

**├── nosql/**

**└── sql/**

&#x20;   **└── migrations/**

**```**



**## Database Design**



**The main entities will include:**



**- Tenants**

**- Users**

**- Customers**

**- Categories**

**- Products**

**- Orders**

**- Order Items**

**- Audit Log**



**The database will use relationships between these entities to support product management, customer management, and order processing.**



**## Multi-Tenancy**



**The system will use a shared-table multi-tenant architecture.**



**Tenant-specific tables will contain a `tenant\_id` column. PostgreSQL Row-Level Security will be used to ensure that one tenant cannot access another tenant's data.**



**## Security**



**The project will implement:**



**- Least-privilege database roles**

**- Row-Level Security**

**- Audit logging**

**- Secure handling of sensitive information**

**- Parameterized queries**

**- Database backups**

**- Test restore procedures**



**## Performance**



**Indexes will be created based on common application and analytical queries.**



**Query performance will be evaluated using `EXPLAIN ANALYZE`. Before-and-after execution plans will be recorded to demonstrate the impact of optimization.**



**Actual measured performance results will be documented rather than using estimated or invented numbers.**



**## NoSQL Integration**



**Redis will be evaluated and integrated for use cases such as:**



**- Shopping cart data**

**- Frequently accessed cached data**



**PostgreSQL will remain the source of truth for permanent business transactions.**



**## Backup and Recovery**



**PostgreSQL backups will be created using the custom dump format.**



**A test restoration will be performed to verify that the backup can be successfully recovered.**



**## Project Documentation**



**The `docs/` directory contains project documentation, including the requirements summary and ER diagram.**



**## Status**



**The project is being developed incrementally according to the capstone requirements:**



**1. Requirements and database design**

**2. Versioned schema migrations**

**3. NoSQL integration**

**4. Query optimization**

**5. Backup and security**

**6. Final walkthrough presentation**

