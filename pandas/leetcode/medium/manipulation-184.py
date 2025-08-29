'''
184. Department Highest Salary

Table: Employee

id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

Table: Department
id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.
'''

import pandas as pd

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    merged_df = pd.merge(employee, department, how = 'inner', left_on = 'departmentId', right_on = 'id')
    max_salaries = merged_df.groupby('departmentId')['salary'].transform('max')
    max_salary_rows = merged_df[merged_df['salary'] == max_salaries]
    max_salary_rows.rename(columns={"name_y": "Department", "name_x": "Employee"}, inplace=True)
    result = max_salary_rows[['Department','Employee','salary']]

    return result