-- 181. Employees Earning More Than Their Managers

-- Table: Employee
-- id (primary key)
-- name (employee name)
-- salary (employee salary)
-- managerId (id of the employee's manager)

-- Task:
-- Find employees who earn more than their managers.
-- Return results in any order.

-- MySQL Query
SELECT 
    e.name AS Employee
FROM Employee e
JOIN Employee ee 
    ON e.managerId = ee.id
WHERE e.salary > ee.salary;
