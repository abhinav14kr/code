--

# 1873. Calculate Special Bonus

**Difficulty:** Easy
**Tag:** SQL

---

## 📘 Problem Description

### **Table: Employees**

| Column Name | Type    |
| ----------- | ------- |
| employee_id | int     |
| name        | varchar |
| salary      | int     |

* `employee_id` is the primary key.
* Each row contains the employee’s ID, name, and salary.

---

## 🎯 Task

Compute each employee’s **special bonus**:

* Bonus = salary
  **if** employee_id is **odd** **AND** name does **not** start with `'M'`
* Bonus = 0
  **otherwise**

Return results **ordered by employee_id**.

---

## ✅ SQL Solution (Untweaked)

```sql
SELECT 
    employee_id, 
    CASE WHEN employee_id %2 = 1 AND name NOT LIKE 'M%' THEN salary ELSE 0 END AS bonus 
FROM Employees
ORDER BY 1 ;
```

---