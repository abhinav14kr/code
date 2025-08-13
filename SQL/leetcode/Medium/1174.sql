'''
1174. Immediate Food Delivery II
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).

If the customers preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
The result format is in the following example.

'''

WITH FIRST_CTE AS (
    SELECT 
        delivery_id, 
        customer_id,
        order_date,
        customer_pref_delivery_date,
        CASE 
            WHEN customer_pref_delivery_date = order_date THEN 'immediate' 
            ELSE 'scheduled' 
        END AS status
    FROM Delivery
), 

SECOND_CTE AS (
    SELECT 
    customer_id,
    MIN(order_date) AS early_date
    FROM Delivery
    GROUP BY customer_id
), 

THIRD_CTE AS (
    SELECT 
        f.delivery_id,
        f.status
    FROM FIRST_CTE f
    JOIN SECOND_CTE s 
      ON f.customer_id = s.customer_id 
     AND f.order_date = s.early_date
),

FINAL_CTE AS (
    SELECT 
        COUNT(*) AS counts,
        SUM(CASE WHEN status = 'immediate' THEN 1 ELSE 0 END) AS res_count
    FROM THIRD_CTE
)

SELECT ROUND((res_count / counts) * 100, 2) AS immediate_percentage
FROM FINAL_CTE;
