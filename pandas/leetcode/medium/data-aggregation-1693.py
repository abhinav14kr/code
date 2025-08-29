'''

1693. Daily Leads and Partners

Table: DailySales

There is no primary key (column with unique values) for this table. It may contain duplicates.
This table contains the date and the name of the product sold and the IDs of the lead and partner it was sold to.
The name consists of only lowercase English letters.

For each date_id and make_name, find the number of distinct lead_id's and distinct partner_id's.
Return the result table in any order.
The result format is in the following example.
 
'''

import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    daily_sales['unique_leads'] = daily_sales.groupby(['date_id', 'make_name'])['lead_id'].transform('nunique')
    daily_sales['unique_partners'] = daily_sales.groupby(['date_id', 'make_name'])['partner_id'].transform('nunique')
    result = daily_sales[['date_id','make_name', 'unique_leads','unique_partners']]
    result = result.drop_duplicates(subset=['date_id', 'make_name', 'unique_leads','unique_partners'], keep = 'first')
    return result



# alternate and efficient solution

import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    result = (
        daily_sales
        .groupby(['date_id', 'make_name'], as_index=False)
        .agg(
            unique_leads=('lead_id', 'nunique'),
            unique_partners=('partner_id', 'nunique')
        )
    )
    return result