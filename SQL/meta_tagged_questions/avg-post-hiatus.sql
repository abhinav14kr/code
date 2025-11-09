# Average Post Hiatus (Part 1) - Facebook SQL Interview Question

**Source:** Facebook SQL Interview Question

---

## Problem Statement

Given a table of Facebook posts, for each user who posted at least twice in **2021**, write a query to find the **number of days** between each user’s **first post** of the year and **last post** of the year in 2021.  

Output the `user_id` and the number of days between each user's first and last post.

---

## Table: `posts`

| Column Name   | Type      |
|---------------|-----------|
| user_id       | integer   |
| post_id       | integer   |
| post_content  | text      |
| post_date     | timestamp |

---

## Example Input

| user_id | post_id | post_content                                                                 | post_date           |
|---------|---------|------------------------------------------------------------------------------|-------------------|
| 151652  | 599415  | Need a hug                                                                    | 07/10/2021 12:00:00 |
| 661093  | 624356  | Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day...    | 07/29/2021 13:00:00 |
| 004239  | 784254  | Happy 4th of July!                                                           | 07/04/2021 11:00:00 |
| 661093  | 442560  | Just going to cry myself to sleep after watching Marley and Me.              | 07/08/2021 14:00:00 |
| 151652  | 111766  | I'm so done with covid - need travelling ASAP!                                | 07/12/2021 19:00:00 |

---

## Example Output

| user_id | days_between |
|---------|--------------|
| 151652  | 2            |
| 661093  | 21           |

> Note: The dataset you are querying against may have different input & output — this is just an example.

---

## Solution

```sql
WITH first_cte AS (
  SELECT 
    user_id
  FROM posts
  WHERE YEAR(post_date) = 2021
  GROUP BY user_id
  HAVING COUNT(post_id) >= 2
),
second_cte AS (
  SELECT 
    p.user_id,
    MIN(p.post_date) AS min_date,
    MAX(p.post_date) AS max_date
  FROM posts p
  INNER JOIN first_cte f 
    ON p.user_id = f.user_id
  WHERE YEAR(p.post_date) = 2021    
  GROUP BY p.user_id
)
SELECT 
  user_id,
  DATEDIFF(max_date, min_date) AS days_between
FROM second_cte;
