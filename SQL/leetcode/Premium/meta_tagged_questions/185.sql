#### QUESTION & ANSWER 

-- 185. Department Top Three Salaries

-- Table: Employee
-- id (primary key)
-- name (varchar)
-- salary (int)
-- departmentId (foreign key referencing Department.id)

-- Table: Department
-- id (primary key)
-- name (varchar)

-- Task:
-- Find all employees who are high earners in their department.
-- A high earner has a salary in the top three unique salaries for that department.
-- Return results in any order.

-- MySQL Query
WITH FIRST_CTE AS (
    SELECT 
        d.name AS Department,
        e.name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY e.departmentId 
            ORDER BY e.salary DESC
        ) AS RANKED
    FROM Employee e
    JOIN Department d 
        ON e.departmentId = d.id
)
SELECT 
    Department, 
    name AS Employee, 
    salary AS Salary
FROM FIRST_CTE
WHERE RANKED <= 3
ORDER BY salary DESC, name ASC;
