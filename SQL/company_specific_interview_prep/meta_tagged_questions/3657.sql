-- 3657. Find Loyal Customers

-- Table: customer_transactions
-- transaction_id (int)      -- unique
-- customer_id (int)
-- transaction_date (date)
-- amount (decimal)
-- transaction_type (varchar)  -- 'purchase' or 'refund'

-- Loyalty Criteria:
-- 1. At least 3 purchase transactions.
-- 2. Active for at least 30 days.
-- 3. Refund rate < 20%
--      refund_rate = (# refunds) / (total transactions)
--
-- Return customer_id ordered ascending.

-- MySQL Query

WITH purchase_cte AS (
    SELECT 
        customer_id,
        COUNT(*) AS purchase_count
    FROM customer_transactions
    WHERE transaction_type = 'purchase'
    GROUP BY customer_id
    HAVING COUNT(*) >= 3
),

activity_cte AS (
    SELECT
        customer_id,
        DATEDIFF(MAX(transaction_date), MIN(transaction_date)) AS active_days
    FROM customer_transactions
    GROUP BY customer_id
),

refund_cte AS (
    SELECT
        customer_id,
        SUM(CASE WHEN transaction_type = 'refund' THEN 1 ELSE 0 END) / COUNT(*) * 1.0 AS refund_rate
    FROM customer_transactions
    GROUP BY customer_id
)

SELECT p.customer_id
FROM purchase_cte p
JOIN activity_cte a ON p.customer_id = a.customer_id
JOIN refund_cte r ON p.customer_id = r.customer_id
WHERE a.active_days >= 30
  AND r.refund_rate < 0.20
ORDER BY p.customer_id ASC;
