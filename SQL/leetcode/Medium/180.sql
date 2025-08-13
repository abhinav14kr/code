'''
180. Consecutive Numbers

Table: Logs

In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.

Find all numbers that appear at least three times consecutively.
Return the result table in any order.
The result format is in the following example.

'''

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.


SOLUTION: 

# Write your MySQL query statement below
SELECT DISTINCT A.num as ConsecutiveNums
FROM Logs as A 
INNER JOIN Logs as B on A.id + 1 = B.id
INNER JOIN Logs as C on B.id + 1 = C.id
WHERE A.num = B.num 
AND B.num = C.num
; 


-- alternate solution using LEAD and LAG 

WITH FIRST_TABLE AS (
  SELECT
    id,
    num,
    LAG(num)  OVER (ORDER BY id)  AS prev_num,
    LEAD(num) OVER (ORDER BY id)  AS next_num
  FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM FIRST_TABLE
WHERE num = prev_num AND num = next_num;
