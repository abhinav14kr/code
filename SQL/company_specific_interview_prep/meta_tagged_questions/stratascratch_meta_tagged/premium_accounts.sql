WITH FIRST_CTE AS
(
    -- 1. Get the initial count (premium_paid_accounts) for the first 7 dates.
    SELECT 
        entry_date, 
        COUNT(account_id) AS initial_paid_count 
    FROM premium_accounts_by_day
    WHERE final_price != 0
    GROUP BY 1
    ORDER BY entry_date
    LIMIT 7
), 
PAID_ACCOUNTS AS (
    -- 2. Select the *list* of premium accounts that were actively paying (final_price != 0)
    SELECT 
        entry_date, 
        account_id
    FROM premium_accounts_by_day
    WHERE final_price != 0
    ORDER BY entry_date
    -- We don't need LIMIT here, as we'll filter using the dates from FIRST_CTE
),
SECOND_CTE AS (
    -- 3. Calculate the count of "retained" paid accounts after 7 days.
    SELECT 
        f.entry_date, 
        COUNT(p_later.account_id) AS retained_paid_count_7d 
    FROM PAID_ACCOUNTS p_initial
    -- Filter only the dates we care about from the first 7
    JOIN FIRST_CTE f
        ON p_initial.entry_date = f.entry_date
    -- Now, join the PAID_ACCOUNTS table *again* to find the status 7 days later
    JOIN PAID_ACCOUNTS p_later 
        ON p_initial.account_id = p_later.account_id -- Same Account ID
        AND p_later.entry_date = p_initial.entry_date + INTERVAL '7 DAY' -- 7 days later
    GROUP BY 1
    ORDER BY 1
)

SELECT 
    f.entry_date, 
    f.initial_paid_count, 
    COALESCE(s.retained_paid_count_7d, 0) AS premium_paid_accounts_after_7d
FROM FIRST_CTE f
LEFT JOIN SECOND_CTE s
    ON f.entry_date = s.entry_date
ORDER BY 1;