-- V2__indexes.sql
-- Indexes for tenant isolation, relationships, and common queries

CREATE INDEX idx_users_tenant_id
    ON users(tenant_id);

CREATE INDEX idx_customers_tenant_id
    ON customers(tenant_id);

CREATE INDEX idx_categories_tenant_id
    ON categories(tenant_id);

CREATE INDEX idx_products_tenant_id
    ON products(tenant_id);

CREATE INDEX idx_products_category_id
    ON products(category_id);

CREATE INDEX idx_orders_tenant_id
    ON orders(tenant_id);

CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX idx_orders_tenant_created_at
    ON orders(tenant_id, created_at);

CREATE INDEX idx_orders_tenant_status
    ON orders(tenant_id, status);

CREATE INDEX idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX idx_order_items_product_id
    ON order_items(product_id);

CREATE INDEX idx_audit_log_tenant_created_at
    ON audit_log(tenant_id, created_at);

CREATE INDEX idx_products_attributes
    ON products USING GIN(attributes);CREATE INDEX idx_orders_tenant_created_at_desc
    ON orders(tenant_id, created_at DESC);