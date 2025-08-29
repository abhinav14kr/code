'''
177. Nth Highest Salary
Table: Employee

id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee. 

Write a solution to find the nth highest distinct salary from the Employee table. If there are less than n distinct salaries, return null.
The result format is in the following example.

'''

import pandas as pd

def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    nth_salary_value = None

    if N > 0:
        unique_salaries = employee['salary'].drop_duplicates()
        sorted_unique_salaries = unique_salaries.sort_values(ascending=False).reset_index(drop=True)

        if len(sorted_unique_salaries) >= N:
            nth_salary_value = sorted_unique_salaries.iloc[N - 1]

    result_df = pd.DataFrame({f'getNthHighestSalary({N})': [nth_salary_value]})
    return result_df
