'''
570. Managers with at Least 5 Direct Reports

Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.
Return the result table in any order.
The result format is in the following example.

'''


SOLUTION:

# Write your MySQL query statement below

WITH first_cte as 
(SELECT managerId, count(id) as counts
from Employee
WHERE managerId <> id AND managerId IS NOT NULL
GROUP BY 1
HAVING counts >= 5
)

SELECT e.name 
FROM first_cte f
INNER JOIN Employee e
ON f.managerId = e.Id; 