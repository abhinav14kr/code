select * from orders;

-- customer, sum(order_cost) in march 2019
-- where year(2019) customer must have made at least one transaction 

WITH FIRST_CTE AS
(
    SELECT cust_id, count(order_details) as order_count
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 2019 AND EXTRACT(MONTH FROM order_date) = 3 
    GROUP BY 1 
    HAVING count(order_details) > 0
), 

SECOND_CTE AS (
    SELECT cust_id, SUM(total_order_cost) as total_revenue
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 2019 AND EXTRACT(MONTH FROM order_date) = 3
    GROUP BY 1
)

SELECT s.cust_id, s.total_revenue
FROM SECOND_CTE s 
JOIN FIRST_CTE f 
ON s.cust_id = f.cust_id
; 