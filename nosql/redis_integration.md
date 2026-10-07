# Redis Integration

## Purpose

Redis is used as a temporary, high-speed shopping cart store for the
Multi-Tenant E-Commerce / Order Management System.

PostgreSQL remains the primary source of truth for customers, products,
orders, and other permanent business data.

## Why Redis

Redis is suitable for shopping carts because it provides fast in-memory
reads and writes and supports key expiration (TTL).

The shopping cart does not need to be stored permanently in Redis.
When an order is completed, the application can read the cart and create
the permanent order and order items in PostgreSQL.

## Redis Cart Design

Cart keys use both the tenant ID and customer ID:

cart:<tenant_id>:customer:<customer_id>

Example:

cart:11111111-1111-1111-1111-111111111111:customer:11111111-1111-1111-1111-111111111113

The Redis hash stores:

product_id -> quantity

Example:

Laptop Pro 15 product ID -> 1

## Tenant Isolation

The tenant ID is included in every cart key.

This prevents different tenants from using the same cart namespace and
supports the multi-tenant design used by PostgreSQL Row-Level Security.

## Expiration

Each shopping cart is given a 1-hour TTL (3,600 seconds).

This prevents abandoned carts from remaining in Redis indefinitely.

## Demonstration

Redis was tested using the following operations:

1. SET and GET were used to verify Redis connectivity.
2. HSET was used to add a product to a shopping cart.
3. HGETALL was used to read the cart.
4. EXPIRE was used to set a 1-hour expiration.
5. TTL confirmed that the expiration was active.
6. EXISTS confirmed that the cart key existed.

Observed TTL during testing:

3,583 seconds remaining.

## PostgreSQL and Redis Responsibilities

PostgreSQL:
- Permanent customers
- Permanent products
- Permanent orders
- Order items
- Audit records
- Multi-tenant security
- Row-Level Security

Redis:
- Temporary shopping carts
- Fast cart reads and writes
- Cart expiration

Redis is not the authoritative database for orders.

## Security Considerations

Redis keys include tenant and customer identifiers to separate carts.

The application must validate that the authenticated user belongs to the
tenant before accessing a cart.

PostgreSQL remains responsible for enforcing permanent tenant isolation
through Row-Level Security.

## Conclusion

Redis provides a suitable NoSQL component for temporary shopping-cart
storage while PostgreSQL remains the system of record for permanent
e-commerce data.
