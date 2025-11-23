-- 183. Customers Who Never Order

-- Table: Customers
-- id (primary key)
-- name (varchar)

-- Table: Orders
-- id (primary key)
-- customerId (foreign key referencing Customers.id)

-- Task:
-- Find all customers who never place an order.
-- Return results in any order.

-- MySQL Query
SELECT 
    name AS 'Customers'
FROM Customers c
LEFT JOIN Orders o 
    ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL;