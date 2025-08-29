'''

1050. Actors and Directors Who Cooperated At Least Three Times

Table: ActorDirector
timestamp is the primary key (column with unique values) for this table. 

Write a solution to find all the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.
Return the result table in any order.
The result format is in the following example. 

'''

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


