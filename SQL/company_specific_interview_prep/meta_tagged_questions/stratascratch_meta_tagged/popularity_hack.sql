SELECT 
    DISTINCT f.location, 
    avg(s.popularity) OVER(PARTITION BY f.location) as avg_popluarity
 FROM facebook_employees f 
JOIN facebook_hack_survey s 
ON f.id = s.employee_id
; 