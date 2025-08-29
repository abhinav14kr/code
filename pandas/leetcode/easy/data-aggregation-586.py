'''

586. Customer Placing the Largest Number of Orders

Table: Orders

order_number is the primary key (column with unique values) for this table.
This table contains information about the order ID and the customer ID.
 
Write a solution to find the customer_number for the customer who has placed the largest number of orders.
The test cases are generated so that exactly one customer will have placed more orders than any other customer.
The result format is in the following example.

'''

import pandas as pd

def largest_orders(orders: pd.DataFrame) -> pd.DataFrame:
    filtered_df = orders.groupby('customer_number')['order_number'].count().reset_index()
    max_row = filtered_df.nlargest(1, 'order_number').reset_index()
    result = max_row[['customer_number']]
    return result