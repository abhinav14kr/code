'''
178. Rank Scores
Table: Scores

id is the primary key (column with unique values) for this table.
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.
 
Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:

The scores should be ranked from the highest to the lowest.
If there is a tie between two scores, both should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.

'''

import pandas as pd

def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    ranked_scores = scores.sort_values(by='score', ascending=False)
    ranked_scores["rank"] = ranked_scores.score.rank(method='dense', ascending=False).astype(int)
    result = ranked_scores[['score','rank']]
    return result