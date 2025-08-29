"""
Problem: 1683. Invalid Tweets

Table: Tweets

tweet_id is the primary key (column with unique values) for this table.
content consists of alphanumeric characters, '!', or ' ' and no other special characters.
This table contains all the tweets in a social media app.

Write a solution to find the IDs of the invalid tweets.
The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
"""

import pandas as pd

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    filtered_df = tweets[tweets['content'].str.len() > 15][['tweet_id']]
    # filtered_df = filtered_df[['tweet_id']]
    return filtered_df
