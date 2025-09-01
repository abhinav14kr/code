[[Pandas]] [[python]] [[leetcode]] #coding [[learning]]
## **Concepts** 

| Type        | What It Is           | Shape     | Think Of It As...       |
| ----------- | -------------------- | --------- | ----------------------- |
| `Series`    | A single column      | 1D (n,)   | A list or column vector |
| `DataFrame` | Table with rows/cols | 2D (n, m) | A spreadsheet or table  |
## **Filtering**

##### Example 1
```
    filtered_df = world[(world['area']>=3000000) | (world['population']>=25000000)]
    filtered_df = filtered_df[['name','population','area']]
```
##### Example 2
``` 
filtered_df = products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')]
filtered_df = filtered_df[['product_id']]
return filtered_df
```
##### Example 3
```
def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    result_df = pd.merge(
    customers,
    orders,
    how='left',
    left_on='id',
    right_on='customerId'
    )
    result_df = result_df[result_df['customerId'].isnull()][['name']].rename(columns={'name':'customers'})
``` 

#### Example 4
```
result_df = views[views['author_id'] == views['viewer_id']]
result_df = result_df[['author_id']].rename(columns={'author_id':'id'})
result_df = result_df.drop_duplicates().sort_values(by='id')
```

## **String Methods**

#### Example 1 
```
def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
	filtered_df = tweets[tweets['content'].str.len() > 15][['tweet_id']]
	return filtered_df
```

#### Example 2 
```
def calculate_special_bonus(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees.apply(
    lambda row: row['salary'] if row['employee_id'] % 2 != 0 and not row['name'].lower().startswith('m') else 0,  axis=1
)
   filtered_df = employees[['employee_id', 'bonus']].sort_values(by='employee_id', ascending = True)
   return filtered_df
```

#### Example 3
```
filtered_df = users[users['mail'].str.contains(r'^[a-zA-Z][a-zA-Z0-9._-]*@leetcode\.com$')]
```


## **Data Manipulation**

#### Example 1
```
def delete_duplicate_emails(person: pd.DataFrame) -> None:
    person.sort_values(by='id', ascending=True, inplace=True)
    person.drop_duplicates(subset='email', keep='first', inplace=True)
```

#### Example 2 
```
def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame:
	melted = pd.melt(products, id_vars = ['product_id'], var_name='store', value_name='price') # # pd.melt() reshapes a DataFrame from wide to long format by turning columns into rows, keeping specified columns as identifiers.
    melted = melted.sort_values(by = 'product_id', ascending=True)
    melted = melted[melted['price'] != 'null']
    return melted
```

#### Example 3
```
def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
	merged_df = pd.merge(employee, department, how = 'inner', left_on = 'departmentId', right_on = 'id')
    max_salaries = merged_df.groupby('departmentId')['salary'].transform('max') # groups by max for all max values if there is a tie
    max_salary_rows = merged_df[merged_df['salary'] == max_salaries] # equates all max values with the merged df to handle ties
    max_salary_rows.rename(columns={"name_y": "Department", "name_x": "Employee"}, inplace=True)
    result = max_salary_rows[['Department','Employee','salary']]
    return result
```

#### Example 4
```
def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    ranked_scores = scores.sort_values(by='score', ascending=False)
    # dense rank function
    ranked_scores["rank"] = ranked_scores.score.rank(method='dense', ascending=False).astype(int)
    result = ranked_scores[['score','rank']]
    return result
```


## **Statistics** 

#### Example 1 
```
def count_salary_categories(accounts: pd.DataFrame) -> pd.DataFrame:
    accounts['category'] = np.where(accounts['income'] < 20000, 'Low Salary',
                           np.where((accounts['income'] >= 20000) & (accounts['income'] <= 50000), 'Average Salary',
                           np.where(accounts['income'] > 50000, 'High Salary', None)))

# equivalent of SQL case statement above and below is counting how many accounts fall into each salary category ('Low', 'Average', 'High'), ensuring all three are listed even if some have zero, and return the result as a DataFrame.

    result = accounts.groupby('category').size().reindex(['Low Salary', 'Average Salary', 'High Salary'], fill_value=0).reset_index(name='accounts_count')

    return result
```


## **Data Aggregation**

#### Example 1
```
import pandas as pd 
def total_time(employees: pd.DataFrame) -> pd.DataFrame:
    # Renaming 'event_day' to 'day' (ensure no extra spaces in column name)
	employees = employees.rename(columns={'event_day': 'day'})
    
    # Calculating  total time spent in the office
    employees['total_time'] = employees['out_time'] - employees['in_time']

    # Group by 'day' and 'emp_id', sum the total time spent, then sorting by 'emp_id'
    result = employees.groupby(['day', 'emp_id'])['total_time'].sum().reset_index().sort_values(by='emp_id', ascending=True)

```

#### Example 2
```
import pandas as pd  
def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    filtered_df = activity.groupby('player_id')['event_date'].min().reset_index()
    result = filtered_df.rename(columns={'event_date': 'first_login'})
    return result
```

#### Example 3
```
import pandas as pd
def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    teacher['cnt'] = teacher.groupby('teacher_id')['subject_id'].transform('nunique')
    result = teacher[['teacher_id', 'cnt']].drop_duplicates()  
    return result
```

#### Example 4
```
import pandas as pd
def largest_orders(orders: pd.DataFrame) -> pd.DataFrame:
    filtered_df = orders.groupby('customer_number')['order_number'].count().reset_index()
    max_row = filtered_df.nlargest(1, 'order_number').reset_index()
    result = max_row[['customer_number']]
    return result
```

#### Example 5
```
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
```


## **Data Integration**

#### Example 1
```
import pandas as pd
def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    filtered_df = actor_director.groupby(['actor_id', 'director_id']).size().reset_index(name='count')
    result = filtered_df.loc[filtered_df['count'] >= 3, ['actor_id', 'director_id']]
    return result

# this can also be return by breaking the last result variable into two lines   

import pandas as pd
def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    filtered_df = actor_director.groupby(['actor_id', 'director_id']).size().reset_index(name='count')
    result = filtered_df[filtered_df['count'] >= 3]
    result = result[['actor_id', 'director_id']]
    return result
```

#### Example 2
```
import pandas as pd
def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    first_merged_df = pd.merge(sales_person[['sales_id','name']], orders[['sales_id','com_id']], on = 'sales_id')
    second_merged_df = pd.merge(first_merged_df[['sales_id', 'name', 'com_id']], company[['com_id', 'name']], on ='com_id')
    red_sales_people = second_merged_df.query('name_y == "RED"')['sales_id'].unique()
    # Excluding those salespeople having to do anything with Company name 'RED' & selecting the 'name' column from the sales_person table
    result = sales_person[~sales_person['sales_id'].isin(red_sales_people)][['name']].drop_duplicates()
    return result
```


#### Example 3
```
import pandas as pd
def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    filtered_df = employee.groupby('managerId')['id'].nunique().reset_index(name='employee_reporting')
    filtered_df = filtered_df[filtered_df['employee_reporting']>=5]
    result = pd.merge(filtered_df,employee, how='inner', left_on = 'managerId', right_on = 'id')
    result = result[['name']]
    return result
```
 

  
  
#pandas


## **rough notes do not bother**

#### **Hacks**
`-- this lets you directly input some input values and convert it into dataframe`

`import pandas as pd`
`from io import StringIO`

`data = """Department,Employee,Salary`
`IT,John,5000`
`IT,Alice,5500`
`HR,Bob,`
`HR,Eva,4500`
`IT,Mark`

#### **code with pen paper**

filtered_df = df.groupby('customer')['products'].count().reset_index
filtered_df = filtered_df[filtered_df['category']== electronics ]]


For each category, calculate:

- Total revenue
- Average price
- Most expensive product name

**Q4.** Add a new column that shows the **rank of price** within each category (highest = rank 1).
**Q5.** Create a pivot table showing total spent by each customer for each category.



filtered_df = df.groupby(''category')['price'].sum()
filtered_df = df.groupby(''category')['price'].avg()
max_row = df.nlargest(1, ''price")['Product']




Task: For each customer, calculate their cumulative spend over time. Then filter to show only the purchases where their cumulative spend crossed $1000.


filtered_df = df.group_by('customer')[['price']].cumsum()




df = df.groupby('Customers', 'Category')['Items'].count()
df = df.groupby('Customers', 'Category')['price'].sum()




Task: Create a pivot table showing the total amount spent by each customer for each product category.

df['total_amount'] = df.groupby('category')['price'].sum()
print(df)

pivot table syntax 

pivot['total']= pivot.groupby('Customer')['Category'].transform('sum)



sorted_df = df.sort_values(by = ['Category','Price']. ascending = ['False', 'False])