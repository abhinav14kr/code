-- 1596. The Most Frequently Ordered Products for Each Customer

-- Table: Customers
-- customer_id (int)    -- primary key
-- name (varchar)

-- Table: Orders
-- order_id (int)       -- primary key
-- order_date (date)
-- customer_id (int)
-- product_id (int)
-- Each order is unique; a customer does not order the same product more than once per day.

-- Table: Products
-- product_id (int)     -- primary key
-- product_name (varchar)
-- price (int)

-- Goal:
-- For every customer who has made at least one order, find the product(s)
-- they ordered most frequently.
-- Return customer_id, product_id, product_name.

-- MySQL Query

WITH FIRST_CTE AS (
    SELECT 
        c.customer_id,
        p.product_id,
        p.product_name,
        COUNT(*) AS frequent_purchase
    FROM Customers c
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    JOIN Products p 
        ON o.product_id = p.product_id
    GROUP BY c.customer_id, p.product_id, p.product_name
),

SECOND_CTE AS (
    SELECT 
        *,
        DENSE_RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY frequent_purchase DESC
        ) AS ranked
    FROM FIRST_CTE
)

SELECT 
    customer_id,
    product_id,
    product_name
FROM SECOND_CTE
WHERE ranked = 1;
