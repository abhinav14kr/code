'''

197. Rising Temperature

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.

'''

SOLUTION: 


# Write your MySQL query statement below
WITH FIRST_TABLE AS (
    SELECT id, recordDate, temperature,
    LAG(temperature, 1, 0) OVER (ORDER BY recordDate) as prev_day_temperature,
    LAG(recordDate, 1, 0) OVER (ORDER BY recordDate) as prev_record_day
    FROM Weather
)

SELECT id 
FROM FIRST_TABLE 
WHERE temperature > prev_day_temperature
AND  recordDate = DATE_ADD(prev_record_day, INTERVAL 1 DAY);

-- alternate solution

SELECT w.id
FROM Weather w 
JOIN Weather WW 
ON DATEDIFF(w.recordDate, ww.recordDate) = 1
WHERE w.temperature > ww.temperature
; 