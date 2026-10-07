&#x20;**# Multi-Tenant E-Commerce / Order Management System**



**## Final Capstone Project Presentation**



**\*\*Technology Stack:\*\* PostgreSQL, Flyway, Redis**  

**\*\*Database:\*\* PostgreSQL 18**  

**\*\*Migration Tool:\*\* Flyway 13.9.0**  

**\*\*NoSQL:\*\* Redis 8.0.5**



**---**



**# Slide 1 — Project Overview**



**## Multi-Tenant E-Commerce / Order Management System**



**This project is a database system designed to support multiple e-commerce businesses using one PostgreSQL database.**



**The system manages:**



**- Tenants**

**- Users**

**- Customers**

**- Product categories**

**- Products**

**- Orders**

**- Order items**

**- Audit records**



**The system focuses on security, performance, reliability, and scalability.**



**---**



**# Slide 2 — Problem Statement**



**Many e-commerce businesses need a reliable system to manage customers, products, orders, and inventory.**



**A multi-tenant system must also ensure that:**



**- Each business can access only its own data.**

**- Important database changes are recorded.**

**- Queries remain efficient as data grows.**

**- Temporary shopping-cart data can be accessed quickly.**

**- Data can be backed up and restored.**



**This project addresses these requirements using PostgreSQL, Redis, and Flyway.**



**---**



**# Slide 3 — Requirements**



**The main requirements were:**



**1. Support multiple tenants.**

**2. Manage users and customers.**

**3. Manage product categories and products.**

**4. Create and manage orders.**

**5. Record important database changes.**

**6. Prevent cross-tenant data access.**

**7. Optimize frequently used queries.**

**8. Integrate a suitable NoSQL component.**

**9. Provide backup and restore capability.**

**10. Apply database security best practices.**



**---**



**# Slide 4 — Database Design**



**## Main Entities**



**The database contains:**



**- tenants**

**- users**

**- customers**

**- categories**

**- products**

**- orders**

**- order\_items**

**- audit\_log**



**## Main Relationships**



**- One tenant can have many users.**

**- One tenant can have many customers.**

**- One tenant can have many categories.**

**- One category can have many products.**

**- One tenant can have many products.**

**- One customer can have many orders.**

**- One order can contain many order items.**

**- One product can appear in many order items.**

**- One tenant can have many audit records.**



**---**



**# Slide 5 — Multi-Tenant Architecture**



**The system uses a shared-table multi-tenant design.**



**Each tenant-owned record contains a `tenant\_id`.**



**Example:**



**`tenant\_id`**



**is used to identify which business owns the record.**



**This approach allows multiple businesses to use the same database while maintaining logical separation between their data.**



**PostgreSQL Row-Level Security provides the main tenant-isolation mechanism.**



**---**



**# Slide 6 — Flyway Database Migrations**



**The database schema is version controlled using Flyway.**



**The migrations are:**



**1. `V1\_\_core\_tables.sql`**

**2. `V2\_\_indexes.sql`**

**3. `V3\_\_audit\_and\_triggers.sql`**

**4. `V4\_\_row\_level\_security.sql`**

**5. `V5\_\_seed\_demo\_data.sql`**



**The migrations are executed in order.**



**A clean migration from an empty database successfully reached:**



**\*\*Version 5\*\***



**This provides a repeatable and version-controlled database setup.**



**---**



**# Slide 7 — Security and RLS**



**## Row-Level Security**



**RLS was enabled on all application tables requiring tenant protection.**



**The policies use:**



**`app.tenant\_id`**



**The restricted `api` role was tested with two tenants.**



**### Tenant A**



**Could see:**



**- Peter Otieno**

**- Sarah Wanjiku**



**### Tenant B**



**Could see:**



**- David Mugisha**



**The tests confirmed that one tenant cannot view another tenant's customer records.**



**---**



**# Slide 8 — Least-Privilege Access**



**The application role is:**



**`api`**



**The role was verified as:**



**- Not a superuser**

**- Not allowed to create databases**

**- Not allowed to create roles**

**- Not allowed to bypass RLS**

**- Allowed to log in**



**The role has `SELECT` access to the eight application tables.**



**This follows the principle of least privilege.**



**---**



**# Slide 9 — Audit Logging**



**PostgreSQL triggers were used to automatically record important changes.**



**Audit triggers were implemented for:**



**- customers**

**- products**

**- orders**



**The audit log records:**



**- Tenant ID**

**- User ID when available**

**- Table name**

**- Record ID**

**- Action**

**- Old data**

**- New data**

**- Timestamp**



**This provides traceability for important business data changes.**



**---**



**# Slide 10 — Redis Integration**



**Redis was integrated as the NoSQL component.**



**Redis is used for temporary shopping-cart data.**



**Example cart key:**



**`cart:<tenant\_id>:customer:<customer\_id>`**



**The cart has a temporary expiration period of one hour.**



**Redis was tested successfully with:**



**`redis-cli ping`**



**Result:**



**`PONG`**



**PostgreSQL remains the source of truth for permanent business data.**



**Redis provides fast access to temporary cart information.**



**---**



**# Slide 11 — Query Optimization**



**A common query retrieves recent orders for a tenant:**



**```sql**

**SELECT order\_id, customer\_id, status, total\_amount, created\_at**

**FROM orders**

**WHERE tenant\_id = '11111111-1111-1111-1111-111111111111'**

**ORDER BY created\_at DESC**

**LIMIT 100;**

**```**



**The performance test used a dataset containing more than 50,000 orders.**



**### Before Optimization**



**Execution time:**



**\*\*12.295 ms\*\***



**The query used a bitmap scan followed by a sort.**



**### Change**



**A composite index was created:**



**`idx\_orders\_tenant\_created\_at\_desc`**



**Index columns:**



**- tenant\_id**

**- created\_at DESC**



**### After Optimization**



**Execution time:**



**\*\*0.067 ms\*\***



**The query used an index scan and avoided the expensive sort.**



**---**



**# Slide 12 — Optimization Result**



**The measured execution time changed from:**



**\*\*12.295 ms → 0.067 ms\*\***



**This represents approximately:**



**\*\*183.5× lower execution time\*\***



**The improvement came from an index that matches both:**



**- the tenant filtering condition**

**- the descending date ordering**



**The result demonstrates the importance of measuring query performance before and after an optimization.**



**---**



**# Slide 13 — Backup and Recovery**



**A PostgreSQL custom-format backup was created using `pg\_dump`.**



**Backup file:**



**`capstone\_backup.dump`**



**The backup was successfully restored into:**



**`capstone\_restore\_test`**



**The restored database contained:**



**- 2 tenants**

**- 2 users**

**- 3 customers**

**- 3 categories**

**- 3 products**

**- 50,003 orders**

**- 4 order items**

**- 50,009 audit records**



**This confirmed that the backup could be restored successfully.**



**---**



**# Slide 14 — Security Controls**



**The project implements several security controls:**



**- Least-privilege database role**

**- Row-Level Security**

**- Tenant isolation**

**- Audit logging**

**- Password hashing for demo users**

**- Parameterized-query requirement**

**- Redis data separation**

**- Backup and restore testing**



**These controls provide multiple layers of protection.**



**---**



**# Slide 15 — Key Technical Decisions**



**## Why PostgreSQL?**



**PostgreSQL provides:**



**- Relational data integrity**

**- Foreign keys**

**- Transactions**

**- JSONB**

**- RLS**

**- Triggers**

**- Indexing**

**- Backup and recovery tools**



**## Why Redis?**



**Redis is suitable for:**



**- Temporary shopping carts**

**- Fast reads**

**- Data with expiration requirements**



**## Why Flyway?**



**Flyway provides:**



**- Version-controlled schema changes**

**- Ordered migrations**

**- Repeatable database setup**

**- Migration history**



**---**



**# Slide 16 — Results**



**The completed system demonstrates:**



**- A structured multi-tenant database**

**- Version-controlled migrations**

**- Tenant-level security**

**- Audit logging**

**- Redis integration**

**- Query optimization**

**- Backup and restore**

**- Least-privilege database access**



**The project successfully combines relational and NoSQL technologies for appropriate use cases.**



**---**



**# Slide 17 — Lessons Learned**



**The project provided practical experience with:**



**1. Database design**

**2. Entity relationships**

**3. PostgreSQL**

**4. Flyway migrations**

**5. Row-Level Security**

**6. Database roles and privileges**

**7. Audit triggers**

**8. Redis**

**9. Query execution plans**

**10. Index optimization**

**11. Backup and restore**

**12. Database security**



**A major lesson was that performance improvements should be measured using actual `EXPLAIN ANALYZE` results rather than assumptions.**



**---**



**# Slide 18 — Conclusion**



**The Multi-Tenant E-Commerce / Order Management System meets the major capstone requirements.**



**The project demonstrates how PostgreSQL can serve as the primary transactional database while Redis handles temporary high-speed data.**



**Security was strengthened through RLS, least-privilege access, and audit logging.**



**Performance was improved through evidence-based indexing.**



**Backup and restore testing demonstrated that the database can be recovered successfully.**



**## Final Outcome**



**\*\*Secure + Performant + Version Controlled + Recoverable + Multi-Tenant\*\***



**---**



**# Slide 19 — Demonstration Flow**



**During the final walkthrough, demonstrate the system in this order:**



**1. Show the project folder and documentation.**

**2. Show the ER diagram.**

**3. Show the Flyway migration files.**

**4. Show the database tables.**

**5. Demonstrate Tenant A RLS.**

**6. Demonstrate Tenant B RLS.**

**7. Show the `api` role permissions.**

**8. Show the audit log.**

**9. Demonstrate Redis with `PONG`.**

**10. Show the query optimization evidence.**

**11. Show the backup file.**

**12. Show the successful restore database.**

**13. Summarize the security and performance results.**



**---**



**# Slide 20 — Thank You**



**## Thank You**



**\*\*Multi-Tenant E-Commerce / Order Management System\*\***



**PostgreSQL + Flyway + Redis**



**\*\*Key message:\*\***



**A well-designed database should be secure, performant, maintainable, and recoverable.**

