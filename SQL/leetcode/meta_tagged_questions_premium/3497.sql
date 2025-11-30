-- 3497. Analyze Subscription Conversion

-- Table: UserActivity
-- user_id (int)
-- activity_date (date)
-- activity_type (varchar)       -- 'free_trial', 'paid', 'cancelled'
-- activity_duration (int)       -- minutes spent that day
-- (user_id, activity_date, activity_type) is unique.

-- Goal:
-- 1. Find users who converted from free_trial → paid.
-- 2. Calculate each user's average daily activity duration 
--      during free_trial (rounded to 2 decimals).
-- 3. Calculate each user's average daily activity duration 
--      during paid subscription (rounded to 2 decimals).
-- Return results ordered by user_id ASC.

-- MySQL Query

WITH FIRST_CTE AS (
    -- Users who have both free_trial and paid activity
    SELECT DISTINCT u.user_id
    FROM UserActivity u
    JOIN UserActivity uu 
        ON u.user_id = uu.user_id
    WHERE u.activity_type = 'free_trial'
      AND uu.activity_type = 'paid'
),

SECOND_CTE AS (
    -- Average free_trial daily activity
    SELECT 
        user_id,
        ROUND(AVG(activity_duration), 2) AS trial_avg_duration
    FROM UserActivity
    WHERE activity_type = 'free_trial'
    GROUP BY user_id
),

THIRD_CTE AS (
    -- Average paid daily activity
    SELECT 
        user_id,
        ROUND(AVG(activity_duration), 2) AS paid_avg_duration
    FROM UserActivity
    WHERE activity_type = 'paid'
    GROUP_BY user_id
)

SELECT 
    f.user_id,
    s.trial_avg_duration,
    t.paid_avg_duration
FROM FIRST_CTE f
JOIN SECOND_CTE s ON f.user_id = s.user_id
JOIN THIRD_CTE t ON f.user_id = t.user_id
ORDER BY f.user_id ASC;
