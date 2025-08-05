import pandas as pd

# Sample data
data = {
    'Date': [
        '2025-07-01', '2025-07-01', '2025-07-02', '2025-07-03', '2025-07-05',
        '2025-07-06', '2025-07-08', '2025-07-09', '2025-07-10', '2025-07-12',
        '2025-07-13', '2025-07-15'
    ],
    'Product': [
        'Laptop', 'Mouse', 'Laptop', 'Laptop', 'Mouse',
        'Keyboard', 'Mouse', 'Laptop', 'Keyboard', 'Laptop',
        'Keyboard', 'Mouse'
    ],
    'Revenue': [1200, 50, 1300, 900, 60, 200, 55, 1500, 300, 1600, 250, 65]
}

df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'])