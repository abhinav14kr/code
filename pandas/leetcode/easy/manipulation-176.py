'''
Table: Employee

id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee. 

Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).
The result format is in the following example. 

'''

import pandas as pd

def second_highest_salary(employee: pd.DataFrame) -> pd.DataFrame:
    unique_salaries = employee['salary'].drop_duplicates()
    filtered_df = unique_salaries.sort_values(ascending=False)

    
    if len(filtered_df) >= 2: 
        second_highest = filtered_df.iloc[1]
    else: 
        second_highest = None

    result = pd.DataFrame({'SecondHighestSalary': [second_highest]})
    return result
