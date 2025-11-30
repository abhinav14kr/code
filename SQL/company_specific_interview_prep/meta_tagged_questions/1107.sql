-- 1107. New Users Daily Count

-- Table: Traffic
-- user_id (int)
-- activity (enum: 'login', 'logout', 'jobs', 'groups', 'homepage')
-- activity_date (date)
-- Table may contain duplicate rows.

-- Goal:
-- For each date within 90 days before 2019-06-30,
-- report the number of users who logged in for the FIRST time on that date.
-- Return results in any order.

-- MySQL Query

WITH FIRST_CTE AS (
    -- First login date for each user
    SELECT 
        user_id, 
        MIN(activity_date) AS activity_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
),

SECOND_CTE AS (
    -- All login activity within the last 90 days
    SELECT 
        user_id, 
        activity_date
    FROM Traffic
    WHERE activity = 'login'
      AND activity_date >= DATE_SUB('2019-06-30', INTERVAL 90 DAY)
)

SELECT 
    f.activity_date AS login_date,
    COUNT(DISTINCT f.user_id) AS user_count
FROM FIRST_CTE f
JOIN SECOND_CTE s 
    ON f.user_id = s.user_id
WHERE f.activity_date = s.activity_date
GROUP BY f.activity_date;
