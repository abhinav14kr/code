-- avg(session time ) = page_exit - page_load
-- MAX(page_load) - min(page_exit)
-- filter page_load < page_exit 

WITH FIRST_CTE AS (
SELECT user_id, DATE(timestamp) as session_date, MAX(timestamp) as min_time
FROM facebook_web_log
WHERE action = 'page_load'
GROUP BY 1,2
), 

SECOND_CTE AS (
SELECT user_id, DATE(timestamp) as session_date, MIN(timestamp) as max_time
FROM facebook_web_log
WHERE action = 'page_exit'
GROUP BY 1,2
)

SELECT 
    f.user_id, 
    AVG(EXTRACT(EPOCH FROM s.max_time - f.min_time)) as average_session_time_seconds
FROM FIRST_CTE f 
JOIN SECOND_CTE s 
ON f.session_date = s.session_date
AND f.user_id = s.user_id
WHERE s.max_time > f.min_time
GROUP BY 1 ;