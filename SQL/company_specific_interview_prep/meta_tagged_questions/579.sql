-- 579. Find Cumulative Salary of an Employee

-- Table: Employee
-- id (int)
-- month (int)
-- salary (int)
-- (id, month) is the primary key.
-- Each row represents an employee's salary for a month in 2020.

-- Task:
-- For each employee and each month they worked:
--   • Compute the 3-month cumulative salary for that month 
--     (current month + previous month + month before that).
--   • If the employee did not work in a previous month → treat missing salary as 0.
--
-- BUT DO NOT include:
--   • The 3-month sum for the employee’s most recent working month.
--   • Any month the employee did not work.
--
-- Return results ordered by:
--   1. id ASC
--   2. month DESC

-- MySQL Query

WITH first_cte AS (
    SELECT *
    FROM Employee
    WHERE (id, month) NOT IN (
        SELECT 
            id,
            MAX(month) AS recent_month
        FROM Employee
        GROUP BY id
    )
),

second_cte AS (
    SELECT
        id,
        month,
        SUM(salary) OVER (
            PARTITION BY id
            ORDER BY month ASC
            RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS salary
    FROM first_cte
)

SELECT *
FROM second_cte
ORDER BY id ASC, month DESC;
