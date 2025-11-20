# 183. Customers Who Never Order

**Difficulty:** Easy
**Tag:** SQL

---

## Problem Description

**Table: Customers**

| Column Name | Type    |
| ----------- | ------- |
| id          | int     |
| name        | varchar |

* `id` is the primary key.
* Each row represents a customer.

**Table: Orders**

| Column Name | Type |
| ----------- | ---- |
| id          | int  |
| customerId  | int  |

* `id` is the primary key.
* `customerId` is a foreign key referencing `Customers.id`.

---

## Task

Find all customers who **never placed an order**.
Return the result table in any order.

---

## SQL Solution (Untweaked)

```sql
SELECT name AS 'Customers'
FROM Customers c
LEFT JOIN Orders o 
ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL;
```