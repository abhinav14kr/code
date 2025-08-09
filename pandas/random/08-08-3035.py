
import pandas as pd

# Sample data
data = {
    'Customer': ['Alice', 'Bob', 'Alice', 'Charlie', 'David', 'Charlie', 'Eve', 'Alice', 'Frank', 'Eve', 'Bob', 'Alice'],
    'Product': ['Laptop', 'Mouse', 'Keyboard', 'Shampoo', 'Soap', 'Toothpaste', 'Pen', 'Notebook', 'Marker', 'Monitor', 'Tablet', 'Laptop'],
    'Category': ['Electronics', 'Electronics', 'Electronics', 'Personal Care', 'Personal Care', 'Personal Care',
                 'Stationery', 'Stationery', 'Stationery', 'Electronics', 'Electronics', 'Electronics'],
    'Price': [1000, 50, 80, 10, 5, 6, 1.5, 3, 2, 300, 400, 1000]
}

df = pd.DataFrame(data)

# ✅ Task:
# 1. Group by Category and Customer, and calculate:
#    - Items_Purchased (count of Product)
#    - Total_Spent (sum of Price)
# 2. For each Category, find the customer with the highest Total_Spent
# Output: Category, Customer, Items_Purchased, Total_Spent

df = df.groupby(['Customer', 'Category']).agg(
    Items_Purchased=('Product', 'count'),
    Total_Spent=('Price', 'sum')
).reset_index()

print(df)

top_spenders = df.sort_values(['Category', 'Total_Spent'], ascending=[True, False])
top_spenders = top_spenders.groupby('Category').first().reset_index()
