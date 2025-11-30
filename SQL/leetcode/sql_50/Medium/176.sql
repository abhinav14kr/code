'''

Second Highest Salary

Table: Employee
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.

Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

'''
SOLUTION: 

SELECT MAX(salary) as SecondHighestSalary 
FROM Employee
WHERE Salary < (SELECT MAX(SALARY) FROM Employee); 