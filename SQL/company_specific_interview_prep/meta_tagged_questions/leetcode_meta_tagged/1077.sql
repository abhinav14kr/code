-- 1077. Project Employees III

-- Table: Project
-- project_id (int)
-- employee_id (int)
-- (project_id, employee_id) is the primary key.
-- Each row shows which employee works on which project.

-- Table: Employee
-- employee_id (int)   -- primary key
-- name (varchar)
-- experience_years (int)

-- Task:
-- For each project, find the employee(s) with the maximum experience.
-- If multiple employees tie for most experienced, return all of them.
-- Return result in any order.

-- MySQL Query

SELECT 
    project_id,
    employee_id
FROM (
    SELECT 
        p.project_id,
        p.employee_id,
        DENSE_RANK() OVER (
            PARTITION BY p.project_id 
            ORDER BY e.experience_years DESC
        ) AS ranked
    FROM Project p
    JOIN Employee e
        ON p.employee_id = e.employee_id
) AS ranked_table
WHERE ranked = 1;
