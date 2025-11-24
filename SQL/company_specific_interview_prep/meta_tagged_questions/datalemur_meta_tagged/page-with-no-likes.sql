-- Facebook Pages with Zero Likes — SQL Interview Question
-- Problem Source: Facebook SQL Interview Question

-- Table: pages
-- page_id (int)
-- page_name (varchar)
--
-- Table: page_likes
-- user_id (int)
-- page_id (int)
-- liked_date (datetime)
--
-- Goal:
-- Return the IDs of Facebook pages that have zero likes.
--
-- Return:
-- page_id (numeric), sorted ascending


WITH pages_with_like_counts AS (
    SELECT 
        p.page_id,
        COUNT(l.user_id) AS like_count
    FROM pages p
    LEFT JOIN page_likes l
      ON p.page_id = l.page_id
    GROUP BY p.page_id
    HAVING COUNT(l.user_id) = 0
)

SELECT
    page_id
FROM pages_with_like_counts
ORDER BY page_id ASC;
