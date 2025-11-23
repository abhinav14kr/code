WITH FIRST_CTE AS (
    select user1, user2 from facebook_friends
    UNION 
    SELECT user2, user1 FROM facebook_friends
    ), 


SECOND_CTE AS (
    SELECT user1, COUNT(user2) as counts
    FROM FIRST_CTE 
    GROUP BY 1 
    ORDER BY 1 
)

SELECT user1, 100.0 * counts / (select count (distinct user1) FROM FIRST_CTE) as popularity_percent
FROM SECOND_CTE
 ; 


