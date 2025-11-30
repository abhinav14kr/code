-- 1873. Calculate Special Bonus
-- Difficulty: Easy
-- Tag: SQL

-- Table: Employees
-- employee_id (primary key)
-- name
-- salary

-- Task:
-- Compute each employee's special bonus:
--   - Bonus = salary if employee_id is odd AND name does not start with 'M'
--   - Bonus = 0 otherwise
-- Return results ordered by employee_id.

-- MySQL Query
SELECT 
    employee_id, 
    CASE 
        WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%' 
        THEN salary 
        ELSE 0 
    END AS bonus
FROM Employees
ORDER BY employee_id;
