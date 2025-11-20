---

# 1112. Highest Grade For Each Student

**Difficulty:** Medium
**Tag:** SQL

---

## 📘 Problem Description

**Table: Enrollments**

| Column Name | Type |
| ----------- | ---- |
| student_id  | int  |
| course_id   | int  |
| grade       | int  |

* `(student_id, course_id)` is the composite primary key.
* `grade` is never NULL.

---

## 🎯 Task

For each student, return the **highest grade** and its **corresponding course**.

* If multiple courses share the same highest grade, return the one with the **smallest course_id**.
* Order the result by **student_id ASC**.

---

## ✅ SQL Solution (Untweaked)

```sql
WITH FIRST_CTE AS
(
SELECT 
    *, 
    DENSE_RANK () OVER (PARTITION BY student_id ORDER BY grade DESC, course_id ASC) as ranked
FROM Enrollments
)

SELECT student_id, course_id, grade
FROM FIRST_CTE 
WHERE ranked = 1;
```

---
