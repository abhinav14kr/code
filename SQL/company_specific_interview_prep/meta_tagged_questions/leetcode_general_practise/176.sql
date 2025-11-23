-- 176. Second Highest Salary

-- Table: Employee
-- id is the primary key.
-- Each row contains the salary of an employee.

-- Task:
-- Find the second highest DISTINCT salary.
-- If no such value exists, return NULL.

-- MySQL Query
SELECT 
    MAX(DISTINCT salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (
    SELECT MAX(salary) 
    FROM Employee
);
