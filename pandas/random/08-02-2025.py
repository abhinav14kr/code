import pandas as pd

# Sample DataFrame
data = {
    'Customer': ['Alice', 'Bob', 'Alice', 'Charlie', 'David', 'Charlie', 'Eve', 'Alice', 'Frank', 'Eve', 'Bob', 'Alice'],
    'Product': ['Laptop', 'Mouse', 'Keyboard', 'Shampoo', 'Soap', 'Toothpaste', 'Pen', 'Notebook', 'Marker', 'Monitor', 'Tablet', 'Laptop'],
    'Category': ['Electronics', 'Electronics', 'Electronics', 'Personal Care', 'Personal Care', 'Personal Care',
                 'Stationery', 'Stationery', 'Stationery', 'Electronics', 'Electronics', 'Electronics'],
    'Price': [1000, 50, 80, 10, 5, 6, 1.5, 3, 2, 300, 400, 1000]
}

df = pd.DataFrame(data)

# group by Category + Customer to compute total spend
grouped = df.groupby(['Category', 'Customer'])['Price'].sum().reset_index(name='Total_Spent')
grouped_sorted = grouped.sort_values(by=['Category', 'Total_Spent'], ascending=[True, False])

# get top 2 per category
top_2 = grouped_sorted.groupby('Category').head(2)
print(top_2)
