'''

607. Sales Person
Pandas Schema
Table: SalesPerson
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| sales_id        | int     |
| name            | varchar |
| salary          | int     |
| commission_rate | int     |
| hire_date       | date    |
+-----------------+---------+
sales_id is the primary key (column with unique values) for this table.
Each row of this table indicates the name and the ID of a salesperson alongside their salary, commission rate, and hire date.
 

Table: Company
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| com_id      | int     |
| name        | varchar |
| city        | varchar |
+-------------+---------+
com_id is the primary key (column with unique values) for this table.
Each row of this table indicates the name and the ID of a company and the city in which the company is located.
 

Table: Orders
+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| order_date  | date |
| com_id      | int  |
| sales_id    | int  |
| amount      | int  |
+-------------+------+
order_id is the primary key (column with unique values) for this table.
com_id is a foreign key (reference column) to com_id from the Company table.
sales_id is a foreign key (reference column) to sales_id from the SalesPerson table.
Each row of this table contains information about one order. This includes the ID of the company, the ID of the salesperson, the date of the order, and the amount paid.
 

Write a solution to find the names of all the salespersons who did not have any orders related to the company with the name "RED".
Return the result table in any order.
The result format is in the following example.

'''


import pandas as pd

def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    first_merged_df = pd.merge(sales_person[['sales_id','name']], orders[['sales_id','com_id']], on = 'sales_id')
    second_merged_df = pd.merge(first_merged_df[['sales_id', 'name', 'com_id']], company[['com_id', 'name']], on ='com_id')
    red_sales_people = second_merged_df.query('name_y == "RED"')['sales_id'].unique()

    # Excluding those salespeople having to do anything with Company name 'RED' & selecting the 'name' column from the sales_person table
    result = sales_person[~sales_person['sales_id'].isin(red_sales_people)][['name']].drop_duplicates()

    return result
    