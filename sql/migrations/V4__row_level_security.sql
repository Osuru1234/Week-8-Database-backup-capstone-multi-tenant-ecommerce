 -- V4__row_level_security.sql
-- Row-Level Security for multi-tenant data isolation

-- Enable Row-Level Security
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Tenants policy
CREATE POLICY tenants_tenant_isolation
ON tenants
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Users policy
CREATE POLICY users_tenant_isolation
ON users
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Customers policy
CREATE POLICY customers_tenant_isolation
ON customers
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Categories policy
CREATE POLICY categories_tenant_isolation
ON categories
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Products policy
CREATE POLICY products_tenant_isolation
ON products
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Orders policy
CREATE POLICY orders_tenant_isolation
ON orders
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);

-- Order items policy
CREATE POLICY order_items_tenant_isolation
ON order_items
USING (
    EXISTS (
        SELECT 1
        FROM orders
        WHERE orders.order_id = order_items.order_id
          AND orders.tenant_id =
              current_setting('app.tenant_id', true)::UUID
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM orders
        WHERE orders.order_id = order_items.order_id
          AND orders.tenant_id =
              current_setting('app.tenant_id', true)::UUID
    )
);

-- Audit log policy
CREATE POLICY audit_log_tenant_isolation
ON audit_log
USING (
    tenant_id = current_setting('app.tenant_id', true)::UUID
)
WITH CHECK (
    tenant_id = current_setting('app.tenant_id', true)::UUID
);