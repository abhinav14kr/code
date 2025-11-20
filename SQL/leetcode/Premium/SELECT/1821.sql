---

# 1821. Find Customers With Positive Revenue This Year

**Difficulty:** Easy
**Tag:** SQL

---

## 📘 Problem Description

### **Table: Customers**

| Column Name | Type |
| ----------- | ---- |
| customer_id | int  |
| year        | int  |
| revenue     | int  |

* `(customer_id, year)` is the composite primary key.
* Revenue can be positive or negative.
* Each row represents a customer’s revenue for a specific year.

---

## 🎯 Task

Return customers whose **total revenue in 2021** is **positive**.
Result can be returned in any order.

---

## ✅ SQL Solution (Untweaked)

```sql
WITH FIRST_CTE AS (
SELECT customer_id, sum(revenue) as  total_revenue
FROM Customers
WHERE year = 2021
GROUP BY 1
)

SELECT customer_id from FIRST_CTE WHERE total_revenue > 0;
```

---