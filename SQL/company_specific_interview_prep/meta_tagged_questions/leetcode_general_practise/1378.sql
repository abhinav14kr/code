# Write your MySQL query statement below
SELECT EE.unique_id, e.name
FROM Employees E 
LEFT JOIN EmployeeUNI EE 
ON E.id = EE.id;