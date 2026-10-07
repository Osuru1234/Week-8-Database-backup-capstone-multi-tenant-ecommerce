 -- V3__audit_and_triggers.sql
-- Audit function and triggers for critical tables

CREATE OR REPLACE FUNCTION audit_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_tenant_id UUID;
    v_user_id UUID;
    v_record_id UUID;
BEGIN
    -- Get the tenant ID from the row being changed
    IF TG_OP = 'DELETE' THEN
        v_tenant_id := OLD.tenant_id;
    ELSE
        v_tenant_id := NEW.tenant_id;
    END IF;

    -- Get the record ID based on the table being audited
    IF TG_TABLE_NAME = 'orders' THEN
        IF TG_OP = 'DELETE' THEN
            v_record_id := OLD.order_id;
        ELSE
            v_record_id := NEW.order_id;
        END IF;

    ELSIF TG_TABLE_NAME = 'products' THEN
        IF TG_OP = 'DELETE' THEN
            v_record_id := OLD.product_id;
        ELSE
            v_record_id := NEW.product_id;
        END IF;

    ELSIF TG_TABLE_NAME = 'customers' THEN
        IF TG_OP = 'DELETE' THEN
            v_record_id := OLD.customer_id;
        ELSE
            v_record_id := NEW.customer_id;
        END IF;
    END IF;

    -- Get the application user ID if it has been set
    BEGIN
        v_user_id := NULLIF(
            current_setting('app.user_id', true),
            ''
        )::UUID;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := NULL;
    END;

    -- Record the change
    IF TG_OP = 'DELETE' THEN

        INSERT INTO audit_log (
            tenant_id,
            user_id,
            table_name,
            record_id,
            action,
            old_data,
            new_data
        )
        VALUES (
            v_tenant_id,
            v_user_id,
            TG_TABLE_NAME,
            v_record_id,
            TG_OP,
            to_jsonb(OLD),
            NULL
        );

        RETURN OLD;

    ELSIF TG_OP = 'INSERT' THEN

        INSERT INTO audit_log (
            tenant_id,
            user_id,
            table_name,
            record_id,
            action,
            old_data,
            new_data
        )
        VALUES (
            v_tenant_id,
            v_user_id,
            TG_TABLE_NAME,
            v_record_id,
            TG_OP,
            NULL,
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSE

        INSERT INTO audit_log (
            tenant_id,
            user_id,
            table_name,
            record_id,
            action,
            old_data,
            new_data
        )
        VALUES (
            v_tenant_id,
            v_user_id,
            TG_TABLE_NAME,
            v_record_id,
            TG_OP,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );

        RETURN NEW;
    END IF;
END;
$$;

CREATE TRIGGER trg_orders_audit
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trg_products_audit
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trg_customers_audit
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION audit_changes();