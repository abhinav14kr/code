'''

626. Exchange Seats
Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.
 
Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.

'''

SOLUTION: 

-- Write your PostgreSQL query statement below
WITH FIRST_CTE AS (
    SELECT S.id as id, T.student as student
    FROM Seat S
    JOIN Seat T
    ON S.id = T.id - 1
    WHERE MOD(s.id, 2) = 1
    ORDER BY S.id ASC
    ), 
SECOND_CTE AS (
    SELECT S.id as id, T.student as student
    FROM Seat S
    JOIN Seat T
    ON S.id = T.id + 1
    WHERE MOD(s.id, 2) = 0
    ORDER BY S.id ASC
), 
THIRD_CTE AS (
    SELECT id, student 
    FROM Seat 
    WHERE id = (SELECT MAX(ID) FROM Seat)
    AND MOD(id, 2) = 1
)

SELECT id, student FROM FIRST_CTE 
UNION ALL 
SELECT id, student FROM SECOND_CTE  
UNION ALL 
SELECT id, student FROM THIRD_CTE  
ORDER BY ID ASC; 

