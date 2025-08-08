import pandas as pd

data = {
    'Customer': ['Alice', 'Bob', 'Alice', 'Charlie', 'Alice', 'Bob', 'Charlie', 'Alice', 'Eve', 'Eve'],
    'Date': [
        '2025-07-01', '2025-07-01', '2025-07-03', '2025-07-04', '2025-07-06',
        '2025-07-07', '2025-07-09', '2025-07-10', '2025-07-10', '2025-07-13'
    ],
    'Product': ['Laptop', 'Mouse', 'Keyboard', 'Shampoo', 'Monitor', 'Tablet', 'Soap', 'Camera', 'Pen', 'Monitor'],
    'Price': [800, 50, 250, 10, 400, 500, 5, 600, 2, 700]
}

df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'])

print(df)   


# Task: For each customer, calculate their cumulative spend over time. Then filter to show only the purchases where their cumulative spend crossed $1000.


df = df.sort_values(by=['Customer', 'Date'])
df['cumsum'] = df.groupby('Customer')[['Price']].cumsum()
df = df[df['cumsum']> 1000]
print(df[['Customer', 'Date', 'Product', 'Price', 'cumsum']])
