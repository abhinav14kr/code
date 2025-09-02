

---

# SQL Practice Notes

## 1. Running Total of Sales by Customer

**Table:**

```
sales_id | customer_id | order_date | amount
------------------------------------------------
1        | 101         | 2024-01-02 | 200
2        | 101         | 2024-01-15 | 150
3        | 102         | 2024-02-01 | 300
4        | 101         | 2024-02-05 | 400
```

**Goal:** Running total of sales per customer by `order_date`.  
**Bonus:** Reset every month.

**My Code:**

```sql
SELECT *, 
SUM(amount) OVER(PARTITION BY MONTH(ORDER_DATE) ORDER BY order_date) as running_sales_by_month 
FROM sales;
```

**Chatgpt Code:**

```sql
-- Running total per customer
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
```

---

## 2. Find Each Customer’s Second Purchase Date

**Goal:** Get the **second purchase date** per customer. Ignore if < 2 purchases.

**My Code:**

```sql
WITH FIRST_CTE AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) as ROW_NUM 
  FROM Sales
)
SELECT * FROM FIRST_CTE 
WHERE ROW_NUM = 2;
```

**Chatgpt Code:**

```sql
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
```

---

## 3. Employee → Top-Level Manager

**Table:**

```
emp_id | emp_name | manager_id
--------------------------------
1      | Alice    | NULL
2      | Bob      | 1
3      | Carol    | 2
4      | David    | 2
5      | Eva      | 3
```

**Goal:** List all employees along with their **top-level manager**.

**My Code:**

```sql
SELECT e.emp_id, e.emp_name, ee.emp_name as manager_name
FROM employees e 
JOIN employees ee 
ON e.emp_id = ee.manager_id 
WHERE ee.manager_name = (SELECT emp_name FROM employees WHERE emp_id = manager_id); 
```

**Chatgpt Code:**

```sql
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
```

---

## 4. First and Last Transaction per Category

**Table:**

```
txn_id | product_category | txn_date  | amount
------------------------------------------------
1      | Electronics      | 2024-01-01 | 500
2      | Electronics      | 2024-01-05 | 700
3      | Furniture        | 2024-01-02 | 200
4      | Furniture        | 2024-01-10 | 900
```

**Goal:** Find first and last transactions per category.

**My Code:**

```sql
SELECT *. FIRST_VALUE(txn_date) OVER(PARTITION BY (product_category ORDER BY txn_date DESC) as first_value, 
LAST_VALUE(txn_date) OVER(PARTITION BY (product_category ORDER BY txn_date DESC) as last_value; 
```

**Chatgpt Code:**

```sql
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
```

---

## 5. Customers Active in 2023

**Table:**

```
cust_id | start_date | end_date
--------------------------------
101     | 2023-01-01 | 2023-05-01
102     | 2023-03-01 | NULL
103     | 2023-02-01 | 2023-04-01
```

**My Code:**

```sql
SELECT cust_id
FROM subscriptions 
WHERE end_date = (SELECT month(end_date) = 2023); 
```

**Chatgpt Code:**

```sql
SELECT DISTINCT cust_id
FROM subscriptions
WHERE end_date >= DATE '2023-01-01'
  AND end_date <  DATE '2024-01-01';
```

---

## 6. Revenue by Quarter (Pivot)

**Table:**

```
order_id | order_date | revenue
--------------------------------
1        | 2024-01-15 | 200
2        | 2024-02-20 | 300
3        | 2024-05-10 | 400
4        | 2024-07-22 | 250
```

**Goal:** Show revenue by quarter as columns.

**My Code:**

```sql
SELECT YEAR(ORDER_DATE) as year, 
SUM (CASE WHEN MONTH(order_date) BETWEEN 1 and 3 THEN REVENUE ELSE 0 ) END AS Q1,
SUM (CASE WHEN MONTH(order_date) BETWEEN 4 and 6 THEN REVENUE ELSE 0 ) END AS Q2,
SUM (CASE WHEN MONTH(order_date) BETWEEN 7 and 9 THEN REVENUE ELSE 0 ) END AS Q3,
SUM (CASE WHEN MONTH(order_date) BETWEEN 10 and 12 THEN REVENUE ELSE 0 ) END AS Q4,
FROM sales;
```

**Chatgpt Code:**

```sql
SELECT
  YEAR(order_date) AS year,
  SUM(CASE WHEN MONTH(order_date) BETWEEN 1 AND 3  THEN revenue ELSE 0 END) AS Q1,
  SUM(CASE WHEN MONTH(order_date) BETWEEN 4 AND 6  THEN revenue ELSE 0 END) AS Q2,
  SUM(CASE WHEN MONTH(order_date) BETWEEN 7 AND 9  THEN revenue ELSE 0 END) AS Q3,
  SUM(CASE WHEN MONTH(order_date) BETWEEN 10 AND 12 THEN revenue ELSE 0 END) AS Q4
FROM sales
GROUP BY YEAR(order_date)
ORDER BY year;
```

