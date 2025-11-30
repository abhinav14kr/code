-- 183. Customers Who Never Order
-- Difficulty: Easy
-- Tag: SQL

-- Table: Customers
-- id (primary key)
-- name

-- Table: Orders
-- id (primary key)
-- customerId (foreign key referencing Customers.id)

-- Task:
-- Find all customers who never placed an order.
-- Return results in any order.

-- MySQL Query
SELECT 
    c.name AS Customers
FROM Customers c
LEFT JOIN Orders o 
    ON c.id = o.customerId
WHERE o.customerId IS NULL;
