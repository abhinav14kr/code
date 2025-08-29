'''

1484. Group Sold Products By The Date
Table Activities:

There is no primary key (column with unique values) for this table. It may contain duplicates.
Each row of this table contains the product name and the date it was sold in a market.
 

Write a solution to find for each date the number of different products sold and their names.
The sold products names for each date should be sorted lexicographically.
Return the result table ordered by sell_date.
The result format is in the following example.

'''

import pandas as pd

def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    # filtered_df = activities.groupby('sell_date')['product'].nunique().reset_index(name='num_sold')
    activities['num_sold'] = activities.groupby('sell_date')['product'].transform('nunique')
    activities = activities.drop_duplicates().reset_index()
    result = (activities.groupby(['sell_date', 'num_sold'])['product']
      .apply(lambda x: ','.join(sorted(x)))
      .reset_index()
      .rename(columns={'product': 'products'}))
    return result