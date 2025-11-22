-- 1821. Find Customers With Positive Revenue This Year
-- Difficulty: Easy
-- Tag: SQL

-- Table: Customers
-- customer_id, year (composite primary key)
-- revenue (can be positive or negative)

-- Task:
-- Return customers whose total revenue in 2021 is positive.
-- Result can be returned in any order.

-- MySQL Query
WITH FIRST_CTE AS (
    SELECT 
        customer_id, 
        SUM(revenue) AS total_revenue
    FROM Customers
    WHERE year = 2021
    GROUP BY customer_id
)
SELECT 
    customer_id
FROM FIRST_CTE
WHERE total_revenue > 0;
