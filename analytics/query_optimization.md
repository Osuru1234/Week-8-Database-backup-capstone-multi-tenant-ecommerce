 # Query Optimization Evidence

## Overview

This document records the query optimization test performed on the
Multi-Tenant E-Commerce / Order Management System.

The objective was to improve a tenant-specific order query that filters
orders by `tenant_id`, sorts them by `created_at` in descending order,
and returns only the most recent 100 orders.

The optimization was measured using PostgreSQL `EXPLAIN ANALYZE` with
real execution statistics.

---

## 1. Query

The query tested was:

```sql
SELECT order_id,
       customer_id,
       status,
       total_amount,
       created_at
FROM orders
WHERE tenant_id = '11111111-1111-1111-1111-111111111111'
ORDER BY created_at DESC
LIMIT 100;
```

The query retrieves the 100 most recent orders belonging to one tenant.

---

## 2. Initial Test

The database initially contained only three orders.

The first execution plan was:

```text
Sort
  Sort Key: created_at DESC
  -> Bitmap Heap Scan on orders
       -> Bitmap Index Scan on idx_orders_tenant_status
```

The measured execution time was:

```text
Execution Time: 0.083 ms
```

Because the table contained only three rows, PostgreSQL could process the
query very quickly. At this small size, an index specifically designed
for the ordering was not necessary.

---

## 3. Performance Test Dataset

To obtain a realistic optimization measurement, 50,000 additional
orders were inserted for the Nairobi Electronics tenant.

The test dataset therefore contained:

```text
50,003 total orders
```

The original three orders were retained.

The additional records were generated only for performance testing.

---

## 4. Before Optimization

With the larger dataset, the query was executed using:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id,
       customer_id,
       status,
       total_amount,
       created_at
FROM orders
WHERE tenant_id = '11111111-1111-1111-1111-111111111111'
ORDER BY created_at DESC
LIMIT 100;
```

The initial plan used the existing tenant index and then sorted the
matching rows.

Important measured results:

```text
Bitmap Index Scan on idx_orders_tenant_status
Bitmap Heap Scan on orders
Sort
Rows returned: 100
Buffers: shared hit=662
Execution Time: 12.295 ms
```

The important part of the plan was:

```text
Bitmap Heap Scan on orders
  -> Bitmap Index Scan on idx_orders_tenant_status
```

followed by:

```text
Sort Key: created_at DESC
Sort Method: top-N heapsort
```

This means PostgreSQL first found the rows belonging to the tenant,
then had to sort the matching rows by `created_at DESC` before returning
the requested 100 rows.

---

## 5. Change

A composite index was created:

```sql
CREATE INDEX idx_orders_tenant_created_at_desc
ON orders(tenant_id, created_at DESC);
```

### Reason for the change

The query filters using:

```text
tenant_id
```

and then requires:

```text
created_at DESC
```

The composite index places both requirements into the same index.

This allows PostgreSQL to locate a tenant's orders and read them in the
required descending date order.

The `LIMIT 100` also means PostgreSQL can stop after finding the first
100 matching rows instead of processing all matching rows.

---

## 6. After Optimization

After creating the composite index, the same query was executed again
with the normal PostgreSQL planner settings.

The optimizer selected:

```text
Index Scan using idx_orders_tenant_created_at_desc
```

The actual execution plan was:

```text
Limit
  -> Index Scan using idx_orders_tenant_created_at_desc on orders
       Index Cond: (tenant_id = '11111111-1111-1111-1111-111111111111')
```

Measured results:

```text
Rows returned: 100
Buffers: shared hit=5
Planning Time: 0.657 ms
Execution Time: 0.067 ms
```

There was no separate Sort operation in the final plan.

---

## 7. Performance Comparison

| Metric | Before | After |
|---|---:|---:|
| Total orders | 50,003 | 50,003 |
| Rows returned | 100 | 100 |
| Main plan | Bitmap Scan + Sort | Index Scan |
| Buffers | 662 | 5 |
| Execution time | 12.295 ms | 0.067 ms |
| Separate Sort | Yes | No |
| Index used | idx_orders_tenant_status | idx_orders_tenant_created_at_desc |

The measured execution time changed from:

```text
12.295 ms
```

to:

```text
0.067 ms
```

This is approximately a 183x reduction in execution time for this
specific test run.

Calculation:

```text
12.295 / 0.067 ≈ 183.5
```

The result should be interpreted as a benchmark from this specific
database state and workload, not as a guaranteed production
performance improvement.

---

## 8. Why the Optimization Worked

The original index was:

```text
(tenant_id, status)
```

It was useful for finding orders belonging to a tenant, but it did not
provide the required `created_at DESC` ordering.

As a result, PostgreSQL had to sort the matching rows.

The new index is:

```text
(tenant_id, created_at DESC)
```

This matches the query's filtering and ordering requirements.

PostgreSQL can therefore:

1. Locate the requested tenant in the index.
2. Read the orders in descending `created_at` order.
3. Return the first 100 rows.
4. Stop without sorting all matching rows.

This reduces both the amount of data processed and the number of
database buffers accessed.

---

## 9. Important Observation

The initial three-row dataset was too small to demonstrate a meaningful
index benefit.

PostgreSQL correctly chose inexpensive plans because scanning a very
small table can be cheaper than performing an index lookup.

After increasing the dataset to 50,003 orders, the optimizer naturally
selected the composite index.

This demonstrates an important database principle:

> Indexes should be designed around actual query patterns, but the
> PostgreSQL optimizer decides whether using an index is beneficial
> based on the estimated cost and available data.

---

## 10. Conclusion

The optimization improved the tenant-specific recent-orders query by
introducing a composite index on:

```text
tenant_id, created_at DESC
```

The final PostgreSQL execution plan used an Index Scan and avoided the
previous sorting step.

The measured execution time in the final test was:

```text
0.067 ms
```

compared with:

```text
12.295 ms
```

before the optimization.

The optimization therefore demonstrates query-driven index design,
actual `EXPLAIN ANALYZE` measurement, and evidence-based performance
tuning.