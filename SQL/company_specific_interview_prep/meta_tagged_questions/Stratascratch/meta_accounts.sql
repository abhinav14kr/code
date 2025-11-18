select * from fb_account_status;

WITH FIRST_CTE AS (
    SELECT COUNT(*) as counts, 
    SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END)  status
    FROM fb_account_status
    WHERE status_date = '2020-01-10'
    )
    
SELECT 1.0 * status / counts as closed_ratio
FROM FIRST_CTE 