-- Monthly Active Users (MAUs) — Facebook SQL Interview Question
-- Problem Source: Ace the Data Science Interview (SQL Chapter #23)

-- Table: user_actions
-- user_id (int)
-- event_id (int)
-- event_type (varchar)   -- 'sign-in', 'like', 'comment'
-- event_date (datetime)
-- 
-- Goal:
-- Count Monthly Active Users (MAUs) for July 2022.
-- Definition: A user is "active" if they performed at least one qualifying action
--             ('sign-in', 'like', 'comment') in BOTH the current month (July 2022)
--             AND the previous month (June 2022).
--
-- Return:
-- month (numeric), monthly_active_users (count)


WITH july_users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 7
      AND event_type IN ('sign-in', 'like', 'comment')
),

june_users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 6
      AND event_type IN ('sign-in', 'like', 'comment')
)

SELECT
    7 AS month,
    COUNT(j.user_id) AS monthly_active_users
FROM july_users j
JOIN june_users u
  ON j.user_id = u.user_id;
