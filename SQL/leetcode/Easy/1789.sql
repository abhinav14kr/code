'''
1789. Primary Department for Each Employee


Table: Employee

(employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
employee_id is the id of the employee.
department_id is the id of the department to which the employee belongs.
primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. If the flag is 'N', the department is not the primary.
 

Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

Return the result table in any order.

'''

SOLUTION: 

WITH FIRST_TABLE AS (
    SELECT employee_id, COUNT(department_id) as counts
    FROM Employee
    GROUP BY employee_id
)
SELECT e.employee_id, e.department_id
FROM Employee e
JOIN FIRST_TABLE f ON e.employee_id = f.employee_id
WHERE 
    (f.counts > 1 AND e.primary_flag = 'Y') 
    OR (f.counts = 1)                       


     -- alternate way using window function 

    
    WITH ranked AS (
  SELECT
    e.*,
    ROW_NUMBER() OVER (
      PARTITION BY employee_id
      ORDER BY (primary_flag = 'Y') DESC
    ) AS rn
  FROM Employee e
)
SELECT employee_id, department_id
FROM ranked
WHERE rn = 1;
