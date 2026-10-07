**# Security Artifact**



**## 1. Overview**



**The Multi-Tenant E-Commerce / Order Management System uses PostgreSQL security features to protect tenant data and control database access.**



**The main security controls implemented are:**



**- Least-privilege database access**

**- Row-Level Security (RLS)**

**- Tenant data isolation**

**- Audit logging**

**- Password hashing for demo users**

**- Parameterized queries requirement**

**- Backup and restore procedures**



**---**



**## 2. Least-Privilege Database Role**



**The application database role is `api`.**



**The `api` role was verified to have:**



**- LOGIN: enabled**

**- SUPERUSER: disabled**

**- CREATE ROLE: disabled**

**- CREATE DATABASE: disabled**

**- REPLICATION: disabled**

**- BYPASS RLS: disabled**



**The `api` role has `SELECT` privileges on the eight application tables:**



**- tenants**

**- users**

**- customers**

**- categories**

**- products**

**- orders**

**- order\_items**

**- audit\_log**



**The role does not have unnecessary INSERT, UPDATE, or DELETE privileges.**



**This follows the principle of least privilege.**



**---**



**## 3. Row-Level Security**



**Row-Level Security (RLS) is enabled on all application tables that contain tenant-related or sensitive data:**



**- tenants**

**- users**

**- customers**

**- categories**

**- products**

**- orders**

**- order\_items**

**- audit\_log**



**The RLS policies use the PostgreSQL session setting:**



**`app.tenant\_id`**



**This ensures that database queries are restricted to the currently selected tenant.**



**---**



**## 4. Tenant Isolation Test**



**RLS was tested using the restricted `api` role.**



**### Tenant A**



**Tenant ID:**



**`11111111-1111-1111-1111-111111111111`**



**The `api` role was configured for Tenant A and queried the customers table.**



**Result:**



**- Peter Otieno**

**- Sarah Wanjiku**



**David Mugisha was not visible because he belongs to Tenant B.**



**### Tenant B**



**Tenant ID:**



**`22222222-2222-2222-2222-222222222222`**



**The `api` role was configured for Tenant B.**



**Result:**



**- David Mugisha**



**Tenant A customers were not visible.**



**### Conclusion**



**The RLS implementation successfully prevents one tenant from viewing another tenant's customer data.**



**---**



**## 5. Audit Logging**



**An audit logging system was implemented using PostgreSQL triggers.**



**Audit triggers are configured on:**



**- customers**

**- products**

**- orders**



**The audit log records:**



**- tenant ID**

**- user ID when available**

**- table name**

**- record ID**

**- action**

**- old data**

**- new data**

**- timestamp**



**This provides a history of important data changes.**



**---**



**## 6. Password Security**



**Demo user passwords are not stored as plain text.**



**The seed data stores a SHA-256 hash generated using PostgreSQL's `digest()` function.**



**Example:**



**`encode(digest('DemoPassword123','sha256'),'hex')`**



**For a production application, a dedicated password hashing algorithm such as Argon2 or bcrypt should be used instead of a simple SHA-256 hash.**



**---**



**## 7. Parameterized Queries**



**The application should use parameterized queries instead of constructing SQL statements by concatenating user input.**



**This reduces the risk of SQL injection.**



**The database migration scripts contain predefined SQL and do not process direct user-supplied query input.**



**---**



**## 8. Redis Security**



**Redis is used for temporary shopping-cart data and high-speed access.**



**Cart keys include the tenant and customer identifiers.**



**Example:**



**`cart:<tenant\_id>:customer:<customer\_id>`**



**Cart data is configured with a temporary expiration period.**



**PostgreSQL remains the primary source of truth for permanent business data.**



**---**



**##**

