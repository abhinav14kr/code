'''
1907. Count Salary Categories
Table: Accounts
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.
'''

import pandas as pd

def count_salary_categories(accounts: pd.DataFrame) -> pd.DataFrame:
    accounts['category'] = np.where(accounts['income'] < 20000, 'Low Salary', 
                           np.where((accounts['income'] >= 20000) & (accounts['income'] <= 50000), 'Average Salary',
                           np.where(accounts['income'] > 50000, 'High Salary', None)))

    result = accounts.groupby('category').size().reindex(['Low Salary', 'Average Salary', 'High Salary'], fill_value=0).reset_index(name='accounts_count')
    return result