-- 184. Department Highest Salary

-- Table: Employee
-- id (int)             -- primary key
-- name (varchar)
-- salary (int)
-- departmentId (int)   -- foreign key to Department.id

-- Table: Department
-- id (int)             -- primary key
-- name (varchar)
-- Department name is guaranteed not NULL

-- Goal:
-- Find employees who have the highest salary in each department.
-- Return the result table in any order.

-- MySQL Query

SELECT 
    Department,
    Employee,
    Salary
FROM (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS ranked
    FROM Employee e
    JOIN Department d
        ON e.departmentId = d.id
) AS ranked_table
WHERE ranked = 1;
