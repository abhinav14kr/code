WITH FIRST_CTE AS (
SELECT
    fb.post_date, 
    fb.post_id,
    count(fb.post_id) as counts
FROM facebook_posts fb 
JOIN facebook_post_views f 
ON fb.post_id = f.post_id
WHERE post_keywords like '%spam%'
GROUP BY 1,2
), 
SECOND_CTE AS (
SELECT 
    fb.post_date, count(f.post_id) as counts
FROM facebook_posts fb 
JOIN facebook_post_views f 
ON fb.post_id = f.post_id
GROUP BY 1
)

SELECT f.post_date, 100.0 *  f.counts / s.counts as spam_share
FROM FIRST_CTE f 
JOIN SECOND_CTE s
ON f.post_date = s.post_date; 