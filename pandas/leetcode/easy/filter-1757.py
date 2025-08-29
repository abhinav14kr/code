"""
Problem: 1757. Recyclable and Low Fat Products

Table: Products

Write a solution to find the ids of products that are both low fat and recyclable.
Return the result table in any order.
"""

import pandas as pd

# SOLUTION 1:
def find_products(products: pd.DataFrame) -> pd.DataFrame:
    filtered_df = products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')]
    filtered_df = filtered_df[['product_id']]
    return filtered_df

# SOLUTION 2:
def find_products(products: pd.DataFrame) -> pd.DataFrame:
    return products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')][['product_id']]
