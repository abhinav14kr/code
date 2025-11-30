-- 3220. Odd and Even Transactions

-- Table: transactions
-- transaction_id (int)       -- unique identifier
-- amount (int)
-- transaction_date (date)
-- Each row contains a transaction's id, amount, and date.

-- Goal:
-- For each date, find the sum of amounts for odd and even transactions.
-- If no odd or even transactions exist for a date, show 0.
-- Return results ordered by transaction_date ascending.

-- MySQL Query

SELECT 
    transaction_date,
    COALESCE(SUM(CASE WHEN amount % 2 = 1 THEN amount END), 0) AS odd_sum,
    COALESCE(SUM(CASE WHEN amount % 2 = 0 THEN amount END), 0) AS even_sum
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date ASC;
