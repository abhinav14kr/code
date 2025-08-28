'''
185.sql Department Top Three Salaries

Table: Employee
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference column) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

Table: Department

id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of a department and its name.

A companys executives are interested in seeing who earns the most money in each of the companys departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
Write a solution to find the employees who are high earners in each of the departments.
Return the result table in any order.

'''



SOLUTION: 

-- Write your PostgreSQL query statement below
WITH FIRST_CTE AS (
    SELECT d.name as Department, e.name, e.salary, DENSE_RANK () OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as RANKED
    FROM Employee e 
    JOIN Department d 
    ON e.departmentId = d.id 
)

SELECT Department, name as Employee , salary as Salary
FROM FIRST_CTE 
WHERE RANKED <= 3
ORDER BY salary DESC, name ASC; 