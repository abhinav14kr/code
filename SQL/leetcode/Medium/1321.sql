'''

1321. Restaurant Growth


Customer
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order.

'''

SOLUTION: 
WITH FIRST_CTE AS (
  SELECT visited_on, SUM(amount) AS total
  FROM Customer
  GROUP BY visited_on
)
SELECT
  visited_on,
  SUM(total) OVER w AS amount,
  ROUND(SUM(total) OVER w / 7, 2) AS average_amount
FROM FIRST_CTE
WINDOW w AS (
  ORDER BY visited_on
  RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
)
LIMIT 6, 999;
