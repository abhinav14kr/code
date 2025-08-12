import pandas as pd

data = {
    'Customer': ['Alice', 'Bob', 'Alice', 'Charlie', 'David', 'Charlie', 'Eve', 'Alice', 'Frank', 'Eve', 'Bob', 'Alice'],
    'Product': ['Laptop', 'Mouse', 'Keyboard', 'Shampoo', 'Soap', 'Toothpaste', 'Pen', 'Notebook', 'Marker', 'Monitor', 'Tablet', 'Laptop'],
    'Category': ['Electronics', 'Electronics', 'Electronics', 'Personal Care', 'Personal Care', 'Personal Care',
                 'Stationery', 'Stationery', 'Stationery', 'Electronics', 'Electronics', 'Electronics'],
    'Price': [1000, 50, 80, 10, 5, 6, 1.5, 3, 2, 300, 400, 1000]
}

df = pd.DataFrame(data)

# creating a pivot table showing the total amount spent by each customer for each product category. 

pivot = df.pivot_table(values='Price', index='Customer', columns='Category', aggfunc='sum') # syntax for pivot table in pandas
print(pivot)


# adding a column showing each customer's overall total spend across all categories.

pivot['total']= pivot.sum(axis=1)
print(pivot)