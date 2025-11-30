-- 1398. Customers Who Bought Products A and B but Not C
-- Difficulty: Medium
-- Tag: SQL

-- Table: Customers
-- customer_id (unique)
-- customer_name

-- Table: Orders
-- order_id (unique)
-- customer_id (links to Customers)
-- product_name

-- Task:
-- Find all customers who bought products A and B but NOT C.
-- Return results ordered by customer_id.
-- These customers should be recommended product C.

-- MySQL Query
SELECT DISTINCT 
    c.customer_id, 
    c.customer_name
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
WHERE c.customer_id IN (
        SELECT c.customer_id
        FROM Customers c
        JOIN Orders o 
            ON c.customer_id = o.customer_id
        WHERE o.product_name = 'A'
    )
  AND c.customer_id IN (
        SELECT c.customer_id
        FROM Customers c
        JOIN Orders o 
            ON c.customer_id = o.customer_id
        WHERE o.product_name = 'B'
    )
  AND c.customer_id NOT IN (
        SELECT c.customer_id
        FROM Customers c
        JOIN Orders o 
            ON c.customer_id = o.customer_id
        WHERE o.product_name = 'C'
    )
ORDER BY c.customer_id;
