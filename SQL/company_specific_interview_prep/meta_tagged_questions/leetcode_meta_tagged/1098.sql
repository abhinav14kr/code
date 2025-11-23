-- 1098. Unpopular Books

-- Table: Books
-- book_id (int)         -- primary key
-- name (varchar)
-- available_from (date)

-- Table: Orders
-- order_id (int)        -- primary key
-- book_id (int)         -- foreign key to Books
-- quantity (int)
-- dispatch_date (date)

-- Task:
-- Report books that have sold **less than 10 copies** in the last year.
-- Exclude books that have been available for **less than 1 month** from '2019-06-23'.
-- Return result as book_id and name, in any order.

-- MySQL Query

WITH first_cte AS (
    SELECT 
        b.book_id,
        b.name,
        COALESCE(SUM(o.quantity), 0) AS num_sold
    FROM Books b
    LEFT JOIN Orders o
        ON b.book_id = o.book_id
        AND o.dispatch_date BETWEEN DATE_ADD(DATE_SUB('2019-06-23', INTERVAL 1 YEAR), INTERVAL 1 DAY)
                               AND '2019-06-23'
    GROUP BY b.book_id, b.name
    HAVING num_sold < 10
),

second_cte AS (
    SELECT book_id
    FROM Books
    WHERE available_from < DATE_SUB('2019-06-23', INTERVAL 30 DAY)
)

SELECT 
    f.book_id,
    f.name
FROM first_cte f
JOIN second_cte s
    ON f.book_id = s.book_id;
