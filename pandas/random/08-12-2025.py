import pandas as pd

data = {
    'Product': ['Laptop', 'Mouse', 'Keyboard', 'Shampoo', 'Soap', 'Toothpaste',
                'Pen', 'Notebook', 'Marker', 'Monitor', 'Tablet', 'Camera', 'Printer', 'Perfume'],
    'Category': ['Electronics', 'Electronics', 'Electronics', 'Personal Care', 'Personal Care', 'Personal Care',
                 'Stationery', 'Stationery', 'Stationery', 'Electronics', 'Electronics', 'Electronics', 'Electronics', 'Personal Care'],
    'Price': [1000, 50, 80, 10, 5, 6, 1.5, 3, 2, 300, 400, 600, 150, 120]
}

df = pd.DataFrame(data)

sorted_df = df.sort_values(by = ['Category','Price'], ascending = [True, False])
print(sorted_df)

top_2 = sorted_df.groupby('Category').head(2)[['Category', 'Product', 'Price']]
print(top_2)


# alternate clean solution 1 to do it 

top_2 = (
    df.sort_values(['Category', 'Price'], ascending=[True, False])
      .groupby('Category')
      .head(2)
      [['Category', 'Product', 'Price']]
)
print(top_2)


# alternate clean solution 2 to do it 

top_2 = df[df.groupby('Category')['Price'].rank(method='first', ascending=False) <= 2]
print(top_2[['Category', 'Product', 'Price']])

