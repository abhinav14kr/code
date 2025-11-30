'''
1164. Product price at a given date
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date. 

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
Return the result table in any order.

'''

SOLUTION: 

-- Write your PostgreSQL query statement below

WITH FIRST_CTE AS (
    SELECT *, ROW_NUMBER () OVER(PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) AS ranked
    FROM PRODUCTS 
    WHERE CHANGE_DATE <= '2019-08-16'
)

SELECT DISTINCT product_id, new_price as price 
FROM FIRST_CTE 
WHERE ranked = 1
UNION 
SELECT product_id, 10 as price
FROM Products 
WHERE product_id NOT IN (SELECT product_id FROM FIRST_CTE); 


-- alternate way 

WITH last_change AS (
  SELECT product_id, MAX(change_date) AS change_date
  FROM Products
  WHERE change_date <= DATE '2019-08-16'
  GROUP BY product_id
)
SELECT
  p.product_id,
  COALESCE(pr.new_price, 10) AS price
FROM (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN last_change lc
  ON lc.product_id = p.product_id
LEFT JOIN Products pr
  ON pr.product_id = lc.product_id
 AND pr.change_date = lc.change_date
ORDER BY p.product_id;
