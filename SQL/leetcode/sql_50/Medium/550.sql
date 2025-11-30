'''
550. Game Play Analysis IV
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to determine the number of players who logged in on the day immediately following their initial login, and divide it by the number of total players.
The result format is in the following example.

'''

WITH FIRST_CTE AS (
  SELECT
    player_id,
    event_date,
    DATEDIFF(
      event_date,
      LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date)
    ) AS difference,
    ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
  FROM Activity
),
SECOND_CTE AS (
  SELECT
    COUNT(DISTINCT player_id) AS counts,
    COUNT(DISTINCT CASE WHEN rn = 2 AND difference = 1 THEN player_id END) AS count_diff
  FROM FIRST_CTE
)
SELECT ROUND(count_diff / counts, 2) AS fraction
FROM SECOND_CTE;
