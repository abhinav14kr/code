'''
In an effort to identify high-value customers, Amazon asked for your help to obtain data about users who go on shopping sprees. A shopping spree occurs when a user makes purchases on 3 or more consecutive days.
List the user IDs who have gone on at least 1 shopping spree in ascending order.
transactions Example Input:
user_id	amount	transaction_date
1	9.99	08/01/2022 10:00:00
1	55	08/17/2022 10:00:00
2	149.5	08/05/2022 10:00:00
2	4.89	08/06/2022 10:00:00
2	34	08/07/2022 10:00:00

Example Output:
user_id
2

Explanation
In this example, user_id 2 is the only one who has gone on a shopping spree.
''' 

WITH FIRST_CTE AS (
  SELECT t.user_id as user_id, t.transaction_date, tt.transaction_date, ttt.transaction_date
  FROM transactions t 
  JOIN transactions  tt
  ON DATE(tt.transaction_date) = DATE(t.transaction_date) + 1
  JOIN transactions  ttt
  ON DATE(ttt.transaction_date) = DATE(t.transaction_date) + 2
  )

SELECT DISTINCT user_id 
FROM FIRST_CTE 
ORDER BY user_id; 

