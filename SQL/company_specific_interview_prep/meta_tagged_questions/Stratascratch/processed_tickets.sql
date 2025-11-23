select * from facebook_complaints;

WITH FIRST_CTE AS (
    SELECT 
        type, 
        SUM(CASE WHEN PROCESSED = 'TRUE' THEN 1 ELSE 0 END)  counts, 
        COUNT(PROCESSED) as total_counts
    FROM facebook_complaints
    GROUP BY 1
    )
    
SELECT type, ROUND((counts * 1.0) /total_counts,2) as processed_rate
FROM FIRST_CTE
;  