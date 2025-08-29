'''

570. Managers with at Least 5 Direct Reports
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.
Return the result table in any order.
The result format is in the following example.

'''

import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    filtered_df = employee.groupby('managerId')['id'].nunique().reset_index(name='employee_reporting')
    filtered_df = filtered_df[filtered_df['employee_reporting']>=5]
    result = pd.merge(filtered_df,employee, how='inner', left_on = 'managerId', right_on = 'id')
    result = result[['name']]
    return result    





    # alternate way of doing it 

    import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    counts = employee.groupby('managerId')['id'].nunique().reset_index(name='employee_reporting')
    managers_with_5_plus = counts[counts['employee_reporting'] >= 5]['managerId']

    # Select rows from employee where id is in the managers_with_5_plus list
    result = employee.loc[employee['id'].isin(managers_with_5_plus), ['name']]
    return result

