"""
Problem: 1148. Article Views I

Table: Views

There is no primary key (column with unique values) for this table, the table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.

Write a solution to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.
"""

import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    result_df = views[views['author_id'] == views['viewer_id']]
    result_df = result_df[['author_id']].rename(columns={'author_id':'id'})
    result_df = result_df.drop_duplicates().sort_values(by='id')
    return result_df
