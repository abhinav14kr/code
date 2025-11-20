---

# 1398. Customers Who Bought Products A and B but Not C

**Difficulty:** Medium
**Tag:** SQL

---

## 📘 Problem Description

### **Table: Customers**

| Column Name   | Type    |
| ------------- | ------- |
| customer_id   | int     |
| customer_name | varchar |

* `customer_id` has unique values.
* `customer_name` is the customer’s name.

---

### **Table: Orders**

| Column Name  | Type    |
| ------------ | ------- |
| order_id     | int     |
| customer_id  | int     |
| product_name | varchar |

* `order_id` is unique.
* `customer_id` links to the customer who bought the product.

---

## 🎯 Task

Find all customers who have purchased **products A and B** but **have not purchased product C**.
Return results ordered by `customer_id`.

These are customers who should be recommended product **C**.

---

## ✅ SQL Solution (Untweaked)

```sql
SELECT 
    DISTINCT c.customer_id, c.customer_name
FROM Customers c 
JOIN Orders o 
ON c.customer_id = o.customer_id
WHERE c.customer_id IN (
    SELECT c.customer_id 
    FROM Customers c 
    JOIN Orders o 
    ON c.customer_id = o.customer_id
    WHERE o.product_name = 'A'
)  
AND c.customer_id IN (
    SELECT c.customer_id 
    FROM Customers c 
    JOIN Orders o 
    ON c.customer_id = o.customer_id
    WHERE o.product_name = 'B'
)  
AND c.customer_id NOT IN (
    SELECT c.customer_id 
    FROM Customers c 
    JOIN Orders o 
    ON c.customer_id = o.customer_id
    WHERE o.product_name = 'c'
)  
ORDER BY c.customer_id;
```

---