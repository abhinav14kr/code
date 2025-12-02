WITH FIRST_CTE AS (
    SELECT date, count(*) as counts 
    FROM fb_Friend_requests
    WHERE action = 'sent'
    GROUP BY 1 
),

SECOND_CTE AS (
SELECT 
    SUM(CASE WHEN f.user_id_sender = fb.user_id_sender AND f.user_id_receiver = fb.user_id_receiver AND f.action = 'accepted' AND fb.action = 'sent' THEN 1 ELSE 0 END) counts,
    fb.date
FROM fb_Friend_requests fb 
JOIN fb_Friend_requests f 
ON f.user_id_sender = fb.user_id_sender
AND f.user_id_receiver = fb.user_id_receiver 
GROUP BY 2
HAVING SUM(CASE WHEN f.user_id_sender = fb.user_id_sender AND f.user_id_receiver = fb.user_id_receiver AND f.action = 'accepted' AND fb.action = 'sent' THEN 1 ELSE 0 END) > 1
) 

SELECT f.date, 1.0 * s.counts / f.counts as percentage_acceptance 
FROM FIRST_CTE f 
JOIN SECOND_CTE s 
ON f.date = s.date; 

