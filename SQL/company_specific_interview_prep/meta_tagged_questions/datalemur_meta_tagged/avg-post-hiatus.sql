-- Average Post Hiatus (Part 1) — Facebook SQL Interview Question
-- Problem Source: Facebook SQL Interview Question

-- Table: posts
-- user_id (int)
-- post_id (int)
-- post_content (text)
-- post_date (timestamp)
--
-- Goal:
-- For users who posted at least twice in 2021, calculate the number of days
-- between their first and last post in 2021.
--
-- Return:
-- user_id, days_between (numeric)


WITH active_users AS (
    SELECT 
        user_id
    FROM posts
    WHERE YEAR(post_date) = 2021
    GROUP BY user_id
    HAVING COUNT(post_id) >= 2
),

user_post_range AS (
    SELECT 
        p.user_id,
        MIN(p.post_date) AS first_post,
        MAX(p.post_date) AS last_post
    FROM posts p
    INNER JOIN active_users u
        ON p.user_id = u.user_id
    WHERE YEAR(p.post_date) = 2021
    GROUP BY p.user_id
)

SELECT
    user_id,
    DATEDIFF(last_post, first_post) AS days_between
FROM user_post_range;
