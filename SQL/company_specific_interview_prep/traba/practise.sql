-- #### SQL Practice Notes

-- ##### 1. Running Total of Sales by Customer

-- **Table:**

-- ```
-- sales_id | customer_id | order_date | amount
-- ------------------------------------------------
-- 1        | 101         | 2024-01-02 | 200
-- 2        | 101         | 2024-01-15 | 150
-- 3        | 102         | 2024-02-01 | 300
-- 4        | 101         | 2024-02-05 | 400
-- ```

-- **Goal:** Running total of sales per customer by `order_date`.  
-- **Bonus:** Reset every month.

-- **My Code:**

SELECT *, 
SUM(amount) OVER(PARTITION BY MONTH(ORDER_DATE) ORDER BY order_date) as running_sales_by_month 
FROM sales;

-- **Chatgpt Code:**

SELECT
    sales_id,
    customer_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales;

-- ---

-- ##### 2. Find Each Customer’s Second Purchase Date

-- **Goal:** Get the **second purchase date** per customer. Ignore if < 2 purchases.

-- **My Code:**

WITH FIRST_CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) as ROW_NUM 
    FROM Sales
)
SELECT * FROM FIRST_CTE 
WHERE ROW_NUM = 2;

-- **Chatgpt Code:**

WITH ranked AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM sales
)
SELECT customer_id, order_date AS second_purchase_date
FROM ranked
WHERE rn = 2;

-- ---

-- ##### 3. Employee → Top-Level Manager

-- **Table:**

-- ```
-- emp_id | emp_name | manager_id
-- --------------------------------
-- 1      | Alice    | NULL
-- 2      | Bob      | 1
-- 3      | Carol    | 2
-- 4      | David    | 2
-- 5      | Eva      | 3
-- ```

-- **Goal:** List all employees along with their **top-level manager**.

-- **My Code:**

SELECT e.emp_id, e.emp_name, ee.emp_name as manager_name
FROM employees e 
JOIN employees ee 
ON e.emp_id = ee.manager_id 
WHERE ee.manager_name = (SELECT emp_name FROM employees WHERE emp_id = manager_id); 

-- **Chatgpt Code:**

WITH RECURSIVE chain AS (
    SELECT emp_id, emp_name, manager_id, emp_id AS root_emp_id, emp_name AS root_emp_name, 0 AS depth
    FROM employees
    UNION ALL
    SELECT c.emp_id, c.emp_name, e.manager_id, c.root_emp_id, c.root_emp_name, depth + 1
    FROM chain c
    JOIN employees e ON c.manager_id = e.emp_id
)
, top_managers AS (
    SELECT emp_id, emp_name, root_emp_id, root_emp_name
    FROM chain
    WHERE manager_id IS NULL
)
SELECT
    e.emp_id,
    e.emp_name,
    tm.emp_name AS top_level_manager
FROM employees e
JOIN top_managers tm ON e.emp_id = tm.root_emp_id
ORDER BY e.emp_id;

-- ---

-- ##### 4. First and Last Transaction per Category

-- **Table:**

-- ```
-- txn_id | product_category | txn_date  | amount
-- ------------------------------------------------
-- 1      | Electronics      | 2024-01-01 | 500
-- 2      | Electronics      | 2024-01-05 | 700
-- 3      | Furniture        | 2024-01-02 | 200
-- 4      | Furniture        | 2024-01-10 | 900
-- ```

-- **Goal:** Find first and last transactions per category.

-- **My Code:**

SELECT *. FIRST_VALUE(txn_date) OVER(PARTITION BY (product_category ORDER BY txn_date DESC) as first_value, 
LAST_VALUE(txn_date) OVER(PARTITION BY (product_category ORDER BY txn_date DESC) as last_value; 

-- **Chatgpt Code:**

WITH w AS (
    SELECT
        product_category,
        txn_date,
        amount,
        FIRST_VALUE(amount) OVER (
            PARTITION BY product_category
            ORDER BY txn_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS first_amount,
        LAST_VALUE(amount) OVER (
            PARTITION BY product_category
            ORDER BY txn_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_amount
    FROM transactions
)
SELECT DISTINCT
    product_category,
    first_amount,
    last_amount
FROM w
ORDER BY product_category;

-- ---

-- ##### 5. Customers Active in 2023

-- **Table:**

-- ```
-- cust_id | start_date | end_date
-- --------------------------------
-- 101     | 2023-01-01 | 2023-05-01
-- 102     | 2023-03-01 | NULL
-- 103     | 2023-02-01 | 2023-04-01
-- ```

-- **My Code:**

SELECT cust_id
FROM subscriptions 
WHERE end_date = (SELECT month(end_date) = 2023); 

-- **Chatgpt Code:**

SELECT DISTINCT cust_id
FROM subscriptions
WHERE end_date >= DATE '2023-01-01'
    AND end_date <  DATE '2024-01-01';

-- ---

-- ##### 6. Revenue by Quarter (Pivot)

-- **Table:**

-- ```
-- order_id | order_date | revenue
-- --------------------------------
-- 1        | 2024-01-15 | 200
-- 2        | 2024-02-20 | 300
-- 3        | 2024-05-10 | 400
-- 4        | 2024-07-22 | 250
-- ```

-- **Goal:** Show revenue by quarter as columns.

-- **My Code:**

SELECT YEAR(ORDER_DATE) as year, 
SUM (CASE WHEN MONTH(order_date) BETWEEN 1 and 3 THEN REVENUE ELSE 0 ) END AS Q1,
SUM (CASE WHEN MONTH(order_date) BETWEEN 4 and 6 THEN REVENUE ELSE 0 ) END AS Q2,
SUM (CASE WHEN MONTH(order_date) BETWEEN 7 and 9 THEN REVENUE ELSE 0 ) END AS Q3,
SUM (CASE WHEN MONTH(order_date) BETWEEN 10 and 12 THEN REVENUE ELSE 0 ) END AS Q4,
FROM sales;

-- **Chatgpt Code:**

SELECT
    YEAR(order_date) AS year,
    SUM(CASE WHEN MONTH(order_date) BETWEEN 1 AND 3  THEN revenue ELSE 0 END) AS Q1,
    SUM(CASE WHEN MONTH(order_date) BETWEEN 4 AND 6  THEN revenue ELSE 0 END) AS Q2,
    SUM(CASE WHEN MONTH(order_date) BETWEEN 7 AND 9  THEN revenue ELSE 0 END) AS Q3,
    SUM(CASE WHEN MONTH(order_date) BETWEEN 10 AND 12 THEN revenue ELSE 0 END) AS Q4
FROM sales
GROUP BY YEAR(order_date)
ORDER BY year;

-- ---

-- ##### 7. Age of Customers

-- **Table:**

-- ```
-- cust_id | name    | birth_date
-- ---------------------------------
-- 1       | Alice   | 1995-02-20
-- 2       | Bob     | 2000-07-15
-- 3       | Charlie | 1988-11-05
-- ```

-- **Goal:** Calculate the **current age** of each customer in years.

-- **My Code:**

SELECT cust_id, name, CURRENT_YEAR - YEAR(birth_date) as birth_year as AGE 
FROM customers
GROUP BY 1,2; 

-- **Chatgpt Code:**

SELECT
    cust_id,
    name,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age_years
FROM customers;

-- ---

-- ##### 8. Order Duration (Hours)

-- **Table:**

-- ```
-- order_id | customer_id | order_date           | shipped_date
-- ----------------------------------------------------------------
-- 1        | 101         | 2024-01-01 10:00:00  | 2024-01-03 14:30:00
-- 2        | 102         | 2024-01-02 09:15:00  | 2024-01-02 20:00:00
-- 3        | 103         | 2024-01-05 12:00:00  | NULL
-- ```

-- **Goal:** Time taken (in hours) to ship each order. **Bonus:** Exclude unshipped.

-- **My Code:**

SELECT ORDER_ID,   TIMESTAMPDIFF(HOUR, order_date, shipped_date) AS hours_diff
FROM orders 
GROUP BY 1; 

-- **Chatgpt Code:**

-- Whole hours, shipped only
SELECT
    order_id,
    TIMESTAMPDIFF(HOUR, order_date, shipped_date) AS hours_to_ship
FROM orders
WHERE shipped_date IS NOT NULL;

-- If you want fractional hours:
-- SELECT order_id, TIMESTAMPDIFF(MINUTE, order_date, shipped_date)/60.0 AS hours_to_ship
-- FROM orders WHERE shipped_date IS NOT NULL;

-- ---

-- ##### 9. Weekend vs Weekday Sales (Totals)

-- **Table:**

-- ```
-- sale_id | customer_id | sale_date   | amount
-- ---------------------------------------------
-- 1       | 101         | 2024-01-06  | 500
-- 2       | 102         | 2024-01-08  | 200
-- 3       | 103         | 2024-01-13  | 300
-- ```

-- **Goal:** Split sales into **Weekend vs Weekday totals**.

-- **My Code:**

SELECT sale_id, 
CASE WHEN DAYOFWEEK(sale_date) IN (1,7) THEN weekday_sale
ELSE weekend_sale
END AS sale_time 
FROM sales; 

-- **Chatgpt Code:**

SELECT
    CASE WHEN DAYOFWEEK(sale_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(amount) AS total_sales
FROM sales
GROUP BY day_type
ORDER BY day_type;

-- In MySQL, `DAYOFWEEK()`: 1=Sunday, 7=Saturday.

-- ---

-- ##### 10. Monthly Cohort Analysis

-- **Table:**

-- ```
-- cust_id | start_date
-- ---------------------
-- 1       | 2024-01-15
-- 2       | 2024-01-20
-- 3       | 2024-02-05
-- 4       | 2024-02-25
-- 5       | 2024-03-03
-- ```

-- **Goal:** Group customers by **cohort month** and count how many joined.

-- **My Code:**

WITH FIRST_CTE AS (
SELECT cust_id, start_date, MONTH(start_date) as subscribed_month
FROM FIRST_CTE 
)
SELECT cust_id, COUNT(subscribed_month) as counts
FROM FIRST_CTE 
GROUP BY 1; 

-- **Chatgpt Code:**

SELECT
    DATE_FORMAT(start_date, '%Y-%m-01') AS cohort_month,
    COUNT(*) AS customers_joined
FROM subscriptions
GROUP BY cohort_month
ORDER BY cohort_month;

-- ---

-- ##### 11. Sessions with 30-Minute Gaps

-- **Table:**

-- ```
-- user_id | activity_time
-- ---------------------------------
-- 1       | 2024-01-01 09:00:00
-- 1       | 2024-01-01 09:10:00
-- 1       | 2024-01-01 11:00:00
-- 2       | 2024-01-02 15:00:00
-- 2       | 2024-01-02 15:05:00
-- ```

-- **Goal:** Define a **session** as activities where the gap between consecutive events ≤ 30 minutes. Assign a **session_id**.

-- **My Code:**

WITH FIRST_CTE AS (
SELECT user_id, activity_time, LEAD(activity_time) OVER(partition by user_id ORDER BY activity_time) as next_time
GROUP BY 1 
)
SELECT CASE WHEN TIMESTAMPDIFF(MINUTE, activity_time, next_time) <= 30 THEN 1 ELSE 0 END as session_definition 
FROM FIRST_CTE ; 

-- **Chatgpt Code:**

WITH stamped AS (
    SELECT
        user_id,
        activity_time,
        CASE
            WHEN LAG(activity_time) OVER (PARTITION BY user_id ORDER BY activity_time) IS NULL
                OR TIMESTAMPDIFF(
                         MINUTE,
                         LAG(activity_time) OVER (PARTITION BY user_id ORDER BY activity_time),
                         activity_time
                     ) > 30
            THEN 1 ELSE 0
        END AS is_new_session
    FROM user_activity
)
SELECT
    user_id,
    activity_time,
    SUM(is_new_session) OVER (
        PARTITION BY user_id
        ORDER BY activity_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS session_id
FROM stamped
ORDER BY user_id, activity_time;

-- ---

-- ##### 12. Rolling 7-Day Sales (Including Current Day)

-- **Table:**

-- ```
-- sale_id | sale_date   | amount
-- --------------------------------
-- 1       | 2024-01-01  | 100
-- 2       | 2024-01-02  | 200
-- 3       | 2024-01-03  | 150
-- 4       | 2024-01-08  | 300
-- 5       | 2024-01-09  | 250
-- ```

-- **Goal:** For each day, compute **total sales in the last 7 days (inclusive)**.

-- **My Code:**

SELECT sale_id, SUM(amount) OVER(PARTITION BY sale_date ORDER BY amount ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as 7_day_sale
FROM sales; 

-- **Chatgpt Code:**

WITH daily AS (
    SELECT sale_date, SUM(amount) AS daily_amount
    FROM sales
    GROUP BY sale_date
)
SELECT
    sale_date,
    SUM(daily_amount) OVER (
        ORDER BY sale_date
        RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
    ) AS rolling_7d_sales
FROM daily
ORDER BY sale_date;

-- ---

-- ##### 13. Rides that Crossed Midnight

-- **Table:**

-- ```
-- ride_id | start_time           | end_time
-- -----------------------------------------------
-- 1       | 2024-01-01 23:30:00  | 2024-01-02 00:30:00
-- 2       | 2024-01-02 22:00:00  | 2024-01-02 23:15:00
-- ```

-- **Goal:** Find rides that **crossed midnight**.

-- **My Code:**

WITH FIRST_CTE AS (
SELECT ride_id, TIMESTAMPDIFF(day, start_time, end_time) as difference
FROM rides
)
SELECT ride_id FROM FIRST_CTE WHERE difference > 1; 

-- **Chatgpt Code:**

SELECT ride_id
FROM rides
WHERE DATE(start_time) <> DATE(end_time);
-- (equivalently) WHERE TIMESTAMPDIFF(DAY, start_time, end_time) >= 1;

-- ---

-- ##### 14. First Login of the Day (Per User)

-- **Table:**

-- ```
-- user_id | login_time
-- --------------------------------
-- 1       | 2024-01-01 09:00:00
-- 1       | 2024-01-01 14:00:00
-- 2       | 2024-01-01 08:30:00
-- 2       | 2024-01-02 10:00:00
-- ```

-- **Goal:** For each user and date, get the **first login of the day**.

-- **My Code:**

SELECT user_id, FIRST_VALUE(login_time) OVER(PARTITION BY user_id ORDER BY login_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_login
FROM logins; 

-- **Chatgpt Code:**

SELECT
    user_id,
    DATE(login_time) AS login_date,
    MIN(login_time) AS first_login
FROM logins
GROUP BY user_id, DATE(login_time)
ORDER BY user_id, login_date;

-- ---

-- Got it 👍 Here’s a **structured Obsidian-friendly version** starting with **number 15** and including answers under each question.

-- ---

-- ##### 15. Orders Late Beyond SLA

-- **Table: `orders`**

-- |order_id|placed_at|delivered_at|
-- |---|---|---|
-- |1|2024-01-01 10:00:00|2024-01-03 14:00:00|
-- |2|2024-01-02 09:00:00|2024-01-02 18:00:00|
-- |3|2024-01-05 11:30:00|NULL|

-- 👉 Write a query to find orders that took more than 48 hours to be delivered.  
-- 👉 Bonus: Count how many such orders happen per week.

-- **Answer:**

-- Orders delivered after 48 hours
SELECT 
        order_id,
        placed_at,
        delivered_at,
        TIMESTAMPDIFF(HOUR, placed_at, delivered_at) AS delivery_hours
FROM orders
WHERE delivered_at IS NOT NULL
    AND TIMESTAMPDIFF(HOUR, placed_at, delivered_at) > 48;

-- Bonus: Count late deliveries per week
SELECT 
        YEARWEEK(placed_at) AS year_week,
        COUNT(*) AS late_orders
FROM orders
WHERE delivered_at IS NOT NULL
    AND TIMESTAMPDIFF(HOUR, placed_at, delivered_at) > 48
GROUP BY YEARWEEK(placed_at);

-- ---

-- ##### 16. Active Subscribers on a Given Date

-- **Table: `subscriptions`**

-- |cust_id|start_date|end_date|
-- |---|---|---|
-- |1|2024-01-01|2024-02-15|
-- |2|2024-01-10|NULL|
-- |3|2024-02-05|2024-03-01|

-- 👉 On `2024-02-10`, find how many subscribers were active (between start_date and end_date).

-- **Answer:**

SELECT COUNT(*) AS active_subscribers
FROM subscriptions
WHERE start_date <= '2024-02-10'
    AND (end_date IS NULL OR end_date >= '2024-02-10');

-- ---

-- ##### 17. Gap Between Purchases

-- **Table: `purchases`**

-- |cust_id|purchase_date|amount|
-- |---|---|---|
-- |101|2024-01-01|50|
-- |101|2024-01-10|100|
-- |101|2024-02-01|75|
-- |102|2024-01-05|200|

-- 👉 For each customer, calculate the days between consecutive purchases.  
-- 👉 Bonus: Find each customer’s average gap.

-- **Answer:**

-- Gap between consecutive purchases
SELECT 
        cust_id,
        purchase_date,
        LAG(purchase_date) OVER (PARTITION BY cust_id ORDER BY purchase_date) AS prev_purchase,
        DATEDIFF(purchase_date, LAG(purchase_date) OVER (PARTITION BY cust_id ORDER BY purchase_date)) AS days_gap
FROM purchases;

-- Bonus: Average gap per customer
SELECT 
        cust_id,
        AVG(DATEDIFF(purchase_date, LAG(purchase_date) OVER (PARTITION BY cust_id ORDER BY purchase_date))) AS avg_gap_days
FROM purchases
GROUP BY cust_id;

-- ---
