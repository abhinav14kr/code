-- 178. Rank Scores

-- Table: Scores
-- id (int, primary key)
-- score (decimal)
--
-- Task:
-- Find the rank of each score.
-- Ranking rules:
-- 1. Highest scores get the top rank.
-- 2. Tied scores receive the same rank.
-- 3. Rankings are consecutive integers (no gaps after ties).
-- Return the result ordered by score descending.

-- MySQL Query
SELECT 
    score, 
    DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores
ORDER BY score DESC;
