**# Multi-Tenant E-Commerce / Order Management System**



**## 1. Project Overview**



**This project is a multi-tenant e-commerce and order management system designed to allow multiple businesses (tenants) to manage their products, customers, and orders using a shared PostgreSQL database.**



**PostgreSQL will be the primary source of truth for business data. The system will use database-level security, auditing, indexes, backup and recovery procedures, and selected NoSQL technology where appropriate.**



**## 2. Users and Tenants**



**The system will support multiple independent tenants. Each tenant represents a separate business using the platform.**



**Users will belong to a specific tenant and will have roles such as administrator, staff, or other authorized roles. Tenant data must remain isolated so that users from one tenant cannot access another tenant's data.**



**## 3. Product Management**



**Each tenant will be able to manage its own products and categories.**



**Products will contain information such as:**

**- Product name**

**- Description**

**- Price**

**- Stock quantity**

**- Category**

**- Creation date**



**A JSONB field will be used for flexible product attributes that may differ between product types, such as electronics specifications or clothing sizes.**



**## 4. Customer Management**



**Each tenant will manage its own customers. Customer information will include:**

**- Customer name**

**- Email**

**- Phone number**

**- Creation date**



**Customers will be associated with only one tenant.**



**## 5. Order Management**



**The system will allow customers to place orders containing one or more products.**



**Orders will store:**

**- Customer**

**- Order status**

**- Total amount**

**- Creation date**



**Order items will store:**

**- Product**

**- Quantity**

**- Unit price**



**The system must maintain relationships between customers, orders, products, and order items.**



**## 6. Multi-Tenant Security**



**The database will use PostgreSQL Row-Level Security (RLS) to prevent users from accessing data belonging to other tenants.**



**Tables containing tenant-specific information will include a `tenant\_id` column. Indexes will use `tenant\_id` as a leading column where appropriate to support both security filtering and query performance.**



**The application will use least-privilege database roles and will not use a PostgreSQL superuser for normal application operations.**



**## 7. Auditing**



**An audit log will record important database changes, including INSERT, UPDATE, and DELETE operations on critical tables.**



**Audit records will contain information such as:**

**- Tenant**

**- User**

**- Affected table**

**- Affected record**

**- Action performed**

**- Previous data where applicable**

**- New data where applicable**

**- Date and time of the change**



**Database triggers will be used to automate the recording of important changes.**



**## 8. Performance and Analytics**



**The system will include indexes designed around common application and analytical queries.**



**Query optimization will be demonstrated using `EXPLAIN ANALYZE` before and after optimization. Actual execution plans and measured execution times will be documented rather than using invented performance numbers.**



**Analytical queries will include examples such as:**

**- Sales by tenant**

**- Sales by product**

**- Orders by status**

**- Revenue over time**

**- Top-selling products**



**## 9. NoSQL Integration**



**Redis will be considered for temporary, high-speed data such as shopping carts and caching.**



**Redis will not replace PostgreSQL as the source of truth for permanent business transactions. The project documentation will explain why Redis is suitable for temporary and frequently accessed data.**



**## 10. Backup and Recovery**



**The project will include PostgreSQL backup procedures using the custom dump format.**



**A test restore will be performed to verify that the backup can actually be used for recovery.**



**Backup and recovery evidence will be documented as part of the final project artifacts.**



**## 11. Main Project Goal**



**The final system should demonstrate an end-to-end database solution that combines:**



**- Relational database design**

**- Multi-tenant architecture**

**- PostgreSQL Row-Level Security**

**- Versioned schema migrations**

**- Database indexes**

**- Query optimization**

**- Audit logging and triggers**

**- Redis integration**

**- Backup and recovery**

**- Database security**

**- Analytical queries**

**- Technical documentation and presentation**

