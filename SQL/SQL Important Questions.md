[[Interview Hub]] [[learning]]

# General SQL Important Interview Questions

##### 1. **Employee & Department** 

Find the name and salary of the highest-paid employee in each department who joined in the last three years, along with their department name and location.

```
-- Assumptions:
-- Employee(emp_id, emp_name, dept_id, salary, join_date)
-- Department(dept_id, dept_name, location)
WITH recent AS (
  SELECT e.emp_id, e.emp_name, e.dept_id, e.salary, e.join_date
  FROM Employee e
  WHERE e.join_date >= CURRENT_DATE - INTERVAL '3' YEAR
),
ranked AS (
  SELECT r.*, 
         DENSE_RANK() OVER (PARTITION BY r.dept_id ORDER BY r.salary DESC) AS rk
  FROM recent r
)
SELECT d.dept_name, d.location, emp_name, salary
FROM ranked r
JOIN Department d ON d.dept_id = r.dept_id
WHERE rk = 1;

```

##### 2. **Orders & Customers** 

Calculate the total order amount for each customer who joined in the current year and has made at least three orders. Output should include `Customer_Name` and total amount, sorted by total amount descending.

```
-- Orders(order_id, customer_id, order_date, amount)
-- Customers(customer_id, customer_name, join_date)
WITH this_year_customers AS (
  SELECT customer_id, customer_name
  FROM Customers
  WHERE EXTRACT(YEAR FROM join_date) = EXTRACT(YEAR FROM CURRENT_DATE)
),
agg AS (
  SELECT o.customer_id,
         COUNT(*) AS order_cnt,
         SUM(o.amount) AS total_amount
  FROM Orders o
  JOIN this_year_customers c ON c.customer_id = o.customer_id
  GROUP BY o.customer_id
)
SELECT c.customer_name, a.total_amount
FROM agg a
JOIN this_year_customers c ON c.customer_id = a.customer_id
WHERE a.order_cnt >= 3
ORDER BY a.total_amount DESC;
```


##### 3. Purchases in **two consecutive months**.

```
-- Purchases(user_id, purchase_date, amount)
WITH months AS (
  SELECT DISTINCT user_id,
         DATE_TRUNC('month', purchase_date) AS m
  FROM Purchases
),
pairs AS (
  SELECT m1.user_id
  FROM months m1
  JOIN months m2
    ON m1.user_id = m2.user_id
   AND m2.m = m1.m + INTERVAL '1 month'
)
SELECT DISTINCT user_id FROM pairs;
```

##### 4. **Transactions Table** 

(`Transaction_id, Account_id, Transaction_Date, Amount, Type [‘credit’ | ‘debit’]`) – Find the account balance for all accounts as of today, assuming the balance starts at zero and only transactions up to today are considered.
```
-- Transactions(txn_id, account_id, txn_date, amount, type ['credit','debit'])
SELECT account_id,
       SUM(CASE WHEN type = 'credit' THEN amount
                WHEN type = 'debit'  THEN -amount ELSE 0 END) AS balance
FROM Transactions
WHERE txn_date < CURRENT_DATE + INTERVAL '1 day'  -- include today (dialect-safe)
GROUP BY account_id;
```

##### 5. Join **Orders, Customers, and Products** 

to find the **top 5 customers by revenue**.

```
-- Orders(order_id, customer_id)
-- OrderItems(order_id, product_id, qty, unit_price)  -- or Orders has total_amount
-- Customers(customer_id, customer_name)
WITH revenue AS (
  SELECT o.customer_id,
         SUM(oi.qty * oi.unit_price) AS total_rev
  FROM Orders o
  JOIN OrderItems oi ON oi.order_id = o.order_id
  GROUP BY o.customer_id
)
SELECT c.customer_name, r.total_rev
FROM revenue r
JOIN Customers c ON c.customer_id = r.customer_id
ORDER BY r.total_rev DESC
FETCH FIRST 5 ROWS ONLY; -- use LIMIT 5 in MySQL/Postgres
```

##### 6. Get the **top 3 products by revenue for each month**.

**Sales Table** (`user_id, product_id, sale_date, price`) 

```
-- Sales(user_id, product_id, sale_date, price, qty?)
-- If qty absent, treat revenue as price.
WITH line AS (
  SELECT product_id,
         DATE_TRUNC('month', sale_date) AS m,
         SUM(COALESCE(qty,1) * price) AS revenue
  FROM Sales
  GROUP BY product_id, DATE_TRUNC('month', sale_date)
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY m ORDER BY revenue DESC) AS rk
  FROM line
)
SELECT m, product_id, revenue
FROM ranked
WHERE rk <= 3
ORDER BY m, revenue DESC;
```


##### 7. From a **customer churn table**, calculate **month-wise churn rate**.

```
-- Customers(customer_id, signup_date)
-- Subscriptions/Activity: define "active" vs "churn". Typical:
-- churned this month = users active last month but NOT active this month.
-- Activity(customer_id, activity_date) with at least one event = active.
WITH months AS (
  SELECT DATE_TRUNC('month', activity_date) AS m, customer_id
  FROM Activity
  GROUP BY 1, 2
),
active AS (
  SELECT m, COUNT(DISTINCT customer_id) AS active_users
  FROM months
  GROUP BY m
),
left_join AS (
  SELECT lm.customer_id,
         DATE_TRUNC('month', lm.activity_date) AS last_m,
         DATE_TRUNC('month', lm.activity_date) + INTERVAL '1 month' AS next_m
  FROM Activity lm
),
churned AS (
  SELECT l.last_m AS m, COUNT(DISTINCT l.customer_id) AS churn_users
  FROM left_join l
  LEFT JOIN months n
    ON n.customer_id = l.customer_id AND n.m = l.next_m
  WHERE n.customer_id IS NULL
  GROUP BY l.last_m
)
SELECT a.m,
       COALESCE(ch.churn_users,0)::DECIMAL / NULLIF(a.active_users,0) AS churn_rate
FROM active a
LEFT JOIN churned ch ON ch.m = a.m
ORDER BY a.m;
```


##### 8. From an **orders table**, calculate the **average basket size** 

(number of items per order) per customer

```
-- Customers(customer_id, signup_date)
-- Subscriptions/Activity: define "active" vs "churn". Typical:
-- churned this month = users active last month but NOT active this month.
-- Activity(customer_id, activity_date) with at least one event = active.
WITH months AS (
  SELECT DATE_TRUNC('month', activity_date) AS m, customer_id
  FROM Activity
  GROUP BY 1, 2
),
active AS (
  SELECT m, COUNT(DISTINCT customer_id) AS active_users
  FROM months
  GROUP BY m
),
left_join AS (
  SELECT lm.customer_id,
         DATE_TRUNC('month', lm.activity_date) AS last_m,
         DATE_TRUNC('month', lm.activity_date) + INTERVAL '1 month' AS next_m
  FROM Activity lm
),
churned AS (
  SELECT l.last_m AS m, COUNT(DISTINCT l.customer_id) AS churn_users
  FROM left_join l
  LEFT JOIN months n
    ON n.customer_id = l.customer_id AND n.m = l.next_m
  WHERE n.customer_id IS NULL
  GROUP BY l.last_m
)
SELECT a.m,
       COALESCE(ch.churn_users,0)::DECIMAL / NULLIF(a.active_users,0) AS churn_rate
FROM active a
LEFT JOIN churned ch ON ch.m = a.m
ORDER BY a.m;
```


##### 9. Display the **third highest salary** 

from an employee dataset.

```
-- Employee(emp_id, salary)
SELECT salary
FROM (
  SELECT DISTINCT salary,
         DENSE_RANK() OVER (ORDER BY salary DESC) AS rk
  FROM Employee
) s
WHERE rk = 3;
```


##### 10. Identify **duplicates 

in a table or across multiple tables**.

```
-- Within one table on (col1,col2,...)
SELECT col1, col2, COUNT(*) AS dup_count
FROM MyTable
GROUP BY col1, col2
HAVING COUNT(*) > 1;

-- Across two tables (same key columns)
SELECT t1.key
FROM Table1 t1
JOIN Table2 t2 ON t2.key = t1.key
GROUP BY t1.key
HAVING COUNT(*) > 1; -- or just SELECT DISTINCT t1.key ... JOIN ...
```

##### 11. Write a **CTE query** to calculate **cumulative monthly sales**.

```
-- Sales(sale_date, amount)
WITH monthly AS (
  SELECT DATE_TRUNC('month', sale_date) AS m,
         SUM(amount) AS month_sum
  FROM Sales
  GROUP BY 1
)
SELECT m,
       month_sum,
       SUM(month_sum) OVER (ORDER BY m
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_sum
FROM monthly
ORDER BY m;
```

##### 12. Use **window functions** 

(`ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`) to solve **ranking problems within partitions** (e.g., top N items per group).

```
-- Example: top 3 products per category by revenue
WITH rev AS (
  SELECT category_id, product_id, SUM(qty*price) AS revenue
  FROM Sales
  GROUP BY category_id, product_id
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY category_id ORDER BY revenue DESC) AS rk
  FROM rev
)
SELECT category_id, product_id, revenue
FROM ranked
WHERE rk <= 3;
```

##### 13. Difference between **`COALESCE()` and `ISNULL()`**.

```
-- COALESCE(expr1, expr2, ...) returns first non-null (ANSI SQL, multi-arg)
-- ISNULL(expr, replacement) is dialect-specific (SQL Server), 2 args only.
-- Example using COALESCE for safe sums:
SELECT COALESCE(discount, 0) AS discount_safe FROM Orders;
```

##### 14. Demonstrate how to **handle missing data** 

and apply **conditional logic** in aggregations.

```
-- Conditional SUM/COUNT with null handling
SELECT
  region,
  SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) AS paid_amount,
  SUM(COALESCE(amount,0)) AS total_amount,
  AVG(CASE WHEN amount IS NOT NULL THEN amount END) AS avg_amount_nonnull
FROM Payments
GROUP BY region;
```

##### 15. Discuss **query optimization techniques**: 

indexes, query refactoring, and best practices for performance tuning.

```
-- Example: ensure selective predicates are sargable and indexed
-- 1) Avoid functions on indexed columns in WHERE
-- 2) Use appropriate JOINs; pre-aggregate before joining large tables
-- 3) Add composite indexes matching (filter, join, order) usage.

-- Skeleton:
-- CREATE INDEX idx_orders_customer_date ON Orders(customer_id, order_date);
-- Then query:
SELECT /*+ use_index(Orders idx_orders_customer_date) */ o.customer_id, SUM(o.amount)
FROM Orders o
WHERE o.customer_id = :cust_id
  AND o.order_date >= :from_date
GROUP BY o.customer_id;
```

##### 16. find the **top 10 products by unit cost or revenue**.

Given **products and sales tables**, 

```
-- Products(product_id, unit_cost)
-- Sales(product_id, qty, price)
WITH rev AS (
  SELECT s.product_id,
         SUM(s.qty * s.price) AS revenue,
         AVG(p.unit_cost) AS unit_cost
  FROM Sales s
  JOIN Products p ON p.product_id = s.product_id
  GROUP BY s.product_id
)
SELECT product_id, revenue, unit_cost
FROM rev
ORDER BY revenue DESC
FETCH FIRST 10 ROWS ONLY;
```

##### 17. **Debug a stored procedure**

and identify major issues affecting correctness or performance.

```
-- General debugging steps in code:
-- 1) Replace SELECT * with explicit columns
-- 2) Move filters before joins; validate JOIN keys; check null semantics
-- 3) Use temp CTEs to isolate logic and row counts
-- Example scaffold:
WITH step1 AS (...),
     step2 AS (SELECT ... FROM step1 JOIN ... ON ... WHERE ...),
     step3 AS (SELECT ... FROM step2 GROUP BY ...)
SELECT * FROM step3;
```

##### 18. Combine data and use aggregate functions 

(`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) to answer business questions such as **total sales per region, average salary per department**.

```
-- Total sales per region; average salary per department
SELECT region, SUM(amount) AS total_sales
FROM Sales
GROUP BY region;

SELECT dept_id, AVG(salary) AS avg_salary
FROM Employee
GROUP BY dept_id;
```

##### 19.  **INNER JOIN** and **LEFT JOIN**.

```
-- INNER: only matching keys
SELECT c.customer_id, o.order_id
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id;

-- LEFT: all left rows, nulls when no match
SELECT c.customer_id, o.order_id
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id;
```


##### 20. **DELETE, TRUNCATE, and DROP**.


```
-- DELETE: remove rows with optional WHERE; logged; triggers fire
DELETE FROM MyTable WHERE created_at < CURRENT_DATE - INTERVAL '30 day';

-- TRUNCATE: remove all rows; usually DDL; fast; cannot use WHERE
TRUNCATE TABLE MyTable;

-- DROP: remove table schema and data
DROP TABLE MyTable;
```

---

# Swiggy Interview Questions – Important

##### 1. **Compute YoY growth in revenue per customer.**

```
-- Orders(customer_id, order_date, amount)
WITH by_year AS (
  SELECT customer_id,
         EXTRACT(YEAR FROM order_date) AS yr,
         SUM(amount) AS rev
  FROM Orders
  GROUP BY 1,2
),
paired AS (
  SELECT a.customer_id,
         a.yr,
         a.rev AS rev_curr,
         b.rev AS rev_prev
  FROM by_year a
  LEFT JOIN by_year b
    ON b.customer_id = a.customer_id
   AND b.yr = a.yr - 1
)
SELECT customer_id, yr,
       rev_curr,
       rev_prev,
       (rev_curr - rev_prev) / NULLIF(rev_prev,0) AS yoy_growth
FROM paired
ORDER BY yr, customer_id;
```


##### 2. **Find suppliers with stock < 50 for 2+ consecutive days.**

```
-- Inventory(supplier_id, as_of_date, stock_qty)
WITH flagged AS (
  SELECT supplier_id, as_of_date,
         CASE WHEN stock_qty < 50 THEN 1 ELSE 0 END AS low
  FROM Inventory
),
grp AS (
  SELECT supplier_id, as_of_date, low,
         as_of_date - INTERVAL '1 day' * 
         (ROW_NUMBER() OVER (PARTITION BY supplier_id ORDER BY as_of_date)) AS g
  FROM flagged
  WHERE low = 1
),
runs AS (
  SELECT supplier_id, COUNT(*) AS streak_len
  FROM grp
  GROUP BY supplier_id, g
)
SELECT DISTINCT supplier_id
FROM runs
WHERE streak_len >= 2;
```

##### 3. **Rank employees by total sales per store for 2023.**

```
-- Sales(emp_id, store_id, sale_date, amount)
WITH y AS (
  SELECT emp_id, store_id, SUM(amount) AS total_sales
  FROM Sales
  WHERE sale_date >= DATE '2023-01-01' AND sale_date < DATE '2024-01-01'
  GROUP BY emp_id, store_id
)
SELECT *,
       RANK() OVER (PARTITION BY store_id ORDER BY total_sales DESC) AS rnk
FROM y
ORDER BY store_id, rnk;
```

##### 4. **Get customers who placed orders from 3 different locations within 10 days.**

```
-- Orders(customer_id, order_date, location_id)
WITH w AS (
  SELECT o.*,
         COUNT(DISTINCT location_id) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
           RANGE BETWEEN INTERVAL '9 days' PRECEDING AND CURRENT ROW
         ) AS loc_cnt_10d
  FROM Orders o
)
SELECT DISTINCT customer_id
FROM w
WHERE loc_cnt_10d >= 3;
```

##### 5. **Find top 5 busiest restaurants by orders per day.**

```
-- Orders(restaurant_id, order_date, order_id)
WITH per_day AS (
  SELECT restaurant_id, CAST(order_date AS DATE) AS d, COUNT(*) AS orders_cnt
  FROM Orders
  GROUP BY restaurant_id, CAST(order_date AS DATE)
),
ranked AS (
  SELECT *,
         RANK() OVER (ORDER BY orders_cnt DESC) AS rnk
  FROM per_day
)
SELECT restaurant_id, d, orders_cnt
FROM ranked
WHERE rnk <= 5
ORDER BY orders_cnt DESC;
```

##### 6. **Retrieve the last successful payment per user.**

```
-- Payments(user_id, payment_time, status)
SELECT DISTINCT ON (user_id)  -- Postgres; in others use window + filter
  user_id, payment_time
FROM Payments
WHERE status = 'success'
ORDER BY user_id, payment_time DESC;

-- Portable:
-- SELECT user_id, payment_time
-- FROM (
--   SELECT p.*,
--          ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY payment_time DESC) AS rn
--   FROM Payments p WHERE status = 'success'
-- ) s WHERE rn = 1;
```

##### 7. **Pivot rider onboarding data into month-wise columns.**

```
-- Riders(rider_id, onboard_date)
-- Postgres: crosstab or conditional aggregation
SELECT
  COUNT(*) FILTER (WHERE DATE_TRUNC('month', onboard_date) = DATE '2025-01-01') AS "2025-01",
  COUNT(*) FILTER (WHERE DATE_TRUNC('month', onboard_date) = DATE '2025-02-01') AS "2025-02"
  -- Add months or generate dynamically in ETL
FROM Riders;
```

##### 8. **Find restaurants with 4+ star ratings consistently for 6 months.**

```
-- Ratings(restaurant_id, rating_date, rating_value)
WITH m AS (
  SELECT restaurant_id,
         DATE_TRUNC('month', rating_date) AS mon,
         AVG(rating_value) AS avg_rating
  FROM Ratings
  GROUP BY 1,2
),
good AS (
  SELECT restaurant_id, mon
  FROM m
  WHERE avg_rating >= 4
),
grp AS (
  SELECT restaurant_id, mon,
         mon - INTERVAL '1 month' * 
         ROW_NUMBER() OVER (PARTITION BY restaurant_id ORDER BY mon) AS g
  FROM good
),
runs AS (
  SELECT restaurant_id, COUNT(*) AS months_good
  FROM grp
  GROUP BY restaurant_id, g
)
SELECT restaurant_id
FROM runs
WHERE months_good >= 6;
```

##### 9. **Compare revenue trends between premium and regular users (MoM).**

```
-- Orders(user_id, order_date, amount)
-- Users(user_id, tier ['premium','regular'])
WITH m AS (
  SELECT u.tier,
         DATE_TRUNC('month', o.order_date) AS mon,
         SUM(o.amount) AS revenue
  FROM Orders o
  JOIN Users u ON u.user_id = o.user_id
  GROUP BY u.tier, DATE_TRUNC('month', o.order_date)
)
SELECT mon,
       SUM(CASE WHEN tier='premium' THEN revenue END) AS premium_rev,
       SUM(CASE WHEN tier='regular' THEN revenue END) AS regular_rev
FROM m
GROUP BY mon
ORDER BY mon;
```

##### 10. **Detect schema drift in historical feedback JSON data.**

```
-- Feedback(id, created_at, payload JSON/JSONB)
-- Postgres JSONB example: list discovered keys per month
WITH keys AS (
  SELECT DATE_TRUNC('month', created_at) AS mon,
         jsonb_object_keys(payload) AS k
  FROM Feedback
),
drift AS (
  SELECT mon, k, COUNT(*) AS cnt
  FROM keys
  GROUP BY mon, k
)
SELECT mon,
       ARRAY_AGG(k ORDER BY k) AS keys_observed
FROM drift
GROUP BY mon
ORDER BY mon;

-- Compare month-to-month keys:
-- SELECT a.mon AS mon, a.k AS key, 
--        CASE WHEN b.k IS NULL THEN 'NEW' ELSE 'EXISTING' END AS status
-- FROM (SELECT DISTINCT mon, k FROM keys) a
-- LEFT JOIN (SELECT DISTINCT mon, k FROM keys) b
--   ON b.k = a.k AND b.mon = a.mon - INTERVAL '1 month';
```

##### 11. **Find delivery partners with 50+ deliveries but none in last 30 days.**

```
-- Deliveries(partner_id, delivery_date, delivery_id)
WITH totals AS (
  SELECT partner_id, COUNT(*) AS total_deliveries,
         MAX(delivery_date) AS last_delivery
  FROM Deliveries
  GROUP BY partner_id
)
SELECT partner_id
FROM totals
WHERE total_deliveries >= 50
  AND last_delivery < CURRENT_DATE - INTERVAL '30 days';
```

##### 12. **Identify users who ordered on all Sundays in the past month.**

```
-- Orders(user_id, order_date)
WITH last_month AS (
  SELECT GENERATE_SERIES(
    DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month'),
    DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day',
    INTERVAL '1 day'
  )::date AS d
),
sundays AS (
  SELECT d FROM last_month WHERE EXTRACT(DOW FROM d) = 0  -- 0=Sunday in Postgres
),
user_sundays AS (
  SELECT o.user_id, CAST(o.order_date AS date) AS d
  FROM Orders o
  JOIN sundays s ON s.d = CAST(o.order_date AS date)
  GROUP BY o.user_id, CAST(o.order_date AS date)
),
counts AS (
  SELECT user_id, COUNT(*) AS sunday_orders
  FROM user_sundays
  GROUP BY user_id
)
SELECT c.user_id
FROM counts c
WHERE c.sunday_orders = (SELECT COUNT(*) FROM sundays);
```

##### 13. **Rank dishes by popularity in each cuisine by month.**

```
-- Orders(order_id, order_date)
-- OrderItems(order_id, dish_id, qty)
-- Dishes(dish_id, cuisine)
WITH m AS (
  SELECT d.cuisine,
         DATE_TRUNC('month', o.order_date) AS mon,
         oi.dish_id,
         SUM(oi.qty) AS qty_sold
  FROM Orders o
  JOIN OrderItems oi ON oi.order_id = o.order_id
  JOIN Dishes d ON d.dish_id = oi.dish_id
  GROUP BY d.cuisine, DATE_TRUNC('month', o.order_date), oi.dish_id
),
r AS (
  SELECT *,
         RANK() OVER (PARTITION BY cuisine, mon ORDER BY qty_sold DESC) AS rnk
  FROM m
)
SELECT cuisine, mon, dish_id, qty_sold, rnk
FROM r
ORDER BY cuisine, mon, rnk;
```

##### 14. **Find duplicate user accounts using phone/email matching.**

```
-- Users(user_id, email, phone)
SELECT COALESCE(LOWER(email), '') AS email_key,
       COALESCE(REGEXP_REPLACE(phone, '\D','','g'), '') AS phone_key,
       COUNT(*) AS cnt,
       ARRAY_AGG(user_id) AS user_ids  -- Postgres
FROM Users
GROUP BY 1,2
HAVING COUNT(*) > 1;
```

##### 15. **Get top cities with most delivery delays during peak hours.**

```
-- Deliveries(city, scheduled_time, delivered_time)
-- Peak hours: 18:00-21:00 local
WITH flagged AS (
  SELECT city,
         scheduled_time,
         delivered_time,
         CASE WHEN delivered_time > scheduled_time THEN 1 ELSE 0 END AS delayed
  FROM Deliveries
  WHERE EXTRACT(HOUR FROM scheduled_time) BETWEEN 18 AND 20
),
city_agg AS (
  SELECT city,
         COUNT(*) AS total_peak,
         SUM(delayed) AS delayed_cnt
  FROM flagged
  GROUP BY city
)
SELECT city, delayed_cnt, total_peak,
       delayed_cnt::DECIMAL / NULLIF(total_peak,0) AS delay_rate
FROM city_agg
ORDER BY delayed_cnt DESC
FETCH FIRST 10 ROWS ONLY;
```

##### 16. **Calculate 7-day moving average of total order value per city.**

```
-- Orders(city, order_date, amount)
WITH daily AS (
  SELECT city, CAST(order_date AS DATE) AS d, SUM(amount) AS daily_sum
  FROM Orders
  GROUP BY city, CAST(order_date AS DATE)
)
SELECT city, d,
       AVG(daily_sum) OVER (
         PARTITION BY city
         ORDER BY d
         ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS ma7
FROM daily
ORDER BY city, d;
```

##### 17. **Find customers whose first and last order are on the same day.**

```
-- Orders(customer_id, order_date)
WITH bounds AS (
  SELECT customer_id,
         MIN(CAST(order_date AS DATE)) AS first_day,
         MAX(CAST(order_date AS DATE)) AS last_day
  FROM Orders
  GROUP BY customer_id
)
SELECT customer_id
FROM bounds
WHERE first_day = last_day;
```

##### 18. **List customers who ordered from 3+ cuisines in the same week.**

```
-- Orders(order_id, customer_id, order_date)
-- OrderItems(order_id, dish_id)
-- Dishes(dish_id, cuisine)
WITH wk AS (
  SELECT o.customer_id,
         DATE_TRUNC('week', o.order_date) AS wk,
         d.cuisine
  FROM Orders o
  JOIN OrderItems oi ON oi.order_id = o.order_id
  JOIN Dishes d ON d.dish_id = oi.dish_id
  GROUP BY o.customer_id, DATE_TRUNC('week', o.order_date), d.cuisine
),
cnt AS (
  SELECT customer_id, wk, COUNT(DISTINCT cuisine) AS cuisines
  FROM wk
  GROUP BY 1,2
)
SELECT customer_id, wk
FROM cnt
WHERE cuisines >= 3;
```

##### 19. **Detect failed orders that later succeeded on retry.**

```
-- Orders(order_id, user_id, created_at, status, retry_group_id)
-- retry_group_id groups attempts for the same intent; if absent, match by user/time window.
WITH grp AS (
  SELECT retry_group_id,
         MAX(CASE WHEN status='success' THEN 1 ELSE 0 END) AS has_success,
         MAX(CASE WHEN status='failed' THEN 1 ELSE 0 END) AS has_failed
  FROM Orders
  GROUP BY retry_group_id
)
SELECT retry_group_id
FROM grp
WHERE has_failed = 1 AND has_success = 1;
```

##### 20. **Identify login streaks of 3+ days for active users.**


```
-- Logins(user_id, login_date date)
WITH dedup AS (
  SELECT DISTINCT user_id, login_date FROM Logins
),
gaps AS (
  SELECT user_id, login_date,
         login_date - INTERVAL '1 day' * 
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) AS grp
  FROM dedup
),
runs AS (
  SELECT user_id, COUNT(*) AS streak_len
  FROM gaps
  GROUP BY user_id, grp
)
SELECT DISTINCT user_id
FROM runs
WHERE streak_len >= 3;
```
