    WITH FIRST_CTE AS (
    SELECT 
    SUM(CASE WHEN country = 'USA' AND status = 'open' THEN 1 ELSE 0 END) as user_counts,  
    COUNT(*) as total_counts  
    FROM fb_active_users
)

SELECT (user_counts * 100.0 / total_counts) AS us_active_share
FROM FIRST_CTE; 



