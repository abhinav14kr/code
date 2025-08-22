'''

1327. List the Products Ordered in a Period
Table: Products
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| product_id       | int     |
| product_name     | varchar |
| product_category | varchar |
+------------------+---------+
product_id is the primary key (column with unique values) for this table.
This table contains data about the companys products.

Table: Orders
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| order_date    | date    |
| unit          | int     |
+---------------+---------+
This table may have duplicate rows.
product_id is a foreign key (reference column) to the Products table.
unit is the number of products ordered in order_date. 

Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
Return the result table in any order.
The result format is in the following example.

'''

# Write your MySQL query statement below
SELECT p.product_name, SUM(o.unit) as unit
FROM Products p
JOIN Orders o
ON p.product_id = o.product_id 
WHERE YEAR(o.order_date) = '2020' and MONTH(o.order_date) = '2'
GROUP BY 1 
HAVING unit >= 100; 