'''

1341. Movie Rating 

Table: Movies

movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.
 

Table: Users

user_id is the primary key (column with unique values) for this table.
The column 'name' has unique values.
Table: MovieRating

(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the users review date. 
 
Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

'''


SOLUTION: 
WITH FIRST_CTE AS (
    SELECT U.name, COUNT(*) AS counts
    FROM MovieRating M
    JOIN Users U
    ON U.user_id = M.user_id
    GROUP BY U.user_id, U.name
    ORDER BY counts DESC, U.name ASC
    LIMIT 1
), 

SECOND_CTE AS (
    SELECT M.title, AVG(MM.rating) as average 
    FROM MovieRating MM 
    JOIN Movies M 
    ON M.movie_id = MM.movie_id
    WHERE MONTH(MM.created_at) = 2 AND YEAR(MM.created_at) = 2020
    GROUP BY 1
    ORDER BY 2 DESC, 1 ASC
    LIMIT 1
)

SELECT name as results FROM FIRST_CTE  
UNION ALL 
SELECT title as results FROM SECOND_CTE; 