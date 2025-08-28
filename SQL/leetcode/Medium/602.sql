'''
602. Friend Requests : Who has the most friends

Table: RequestAccepted

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted. 

Write a solution to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.


'''

SOLUTION: 


-- Write your PostgreSQL query statement below
With FIRST_CTE AS (
    SELECT requester_id as id 
    FROM RequestAccepted 
    UNION ALL 
    SELECT accepter_id as id 
    FROM RequestAccepted 
)

SELECT id, COUNT(id) as num 
FROM FIRST_CTE 
GROUP BY 1
ORDER BY COUNT(id) DESC 
LIMIT 1 ; 

-- alternate solution for this 

SELECT id, COUNT(*) as num
FROM (
    SELECT requester_id as id from RequestAccepted
    UNION ALL 
    SELECT accepter_id as id from RequestAccepted
) as ends   
GROUP BY 1
ORDER BY counts DESC
LIMIT 1; 