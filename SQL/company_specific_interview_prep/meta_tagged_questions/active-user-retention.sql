# Monthly Active Users (MAUs) - Facebook SQL Interview Question

**Source:** Problem #23 in the SQL Chapter of *Ace the Data Science Interview*

---

## Problem Statement

Assume you're given a table containing information on Facebook user actions.  

Write a query to obtain the **number of monthly active users (MAUs)** in **July 2022**, including the month in numerical format ("1, 2, 3").  

**Hint:**  
An active user is defined as a user who has performed actions such as `'sign-in'`, `'like'`, or `'comment'` in **both the current month and the previous month**.

---

## Table: `user_actions`

| Column Name | Type    |
|------------|---------|
| user_id    | integer |
| event_id   | integer |
| event_type | string  |  ("sign-in", "like", "comment") |
| event_date | datetime |

**Example Input:**

| user_id | event_id | event_type | event_date           |
|---------|----------|------------|--------------------|
| 445     | 7765     | sign-in    | 05/31/2022 12:00:00 |
| 742     | 6458     | sign-in    | 06/03/2022 12:00:00 |
| 445     | 3634     | like       | 06/05/2022 12:00:00 |
| 742     | 1374     | comment    | 06/05/2022 12:00:00 |
| 648     | 3124     | like       | 06/18/2022 12:00:00 |

---

## Example Output for June 2022

| month | monthly_active_users |
|-------|--------------------|
| 6     | 1                  |

**Explanation:**  
In June 2022, there was only one monthly active user (`user_id = 445`).  

> Note: The output is for June 2022 because the example table only contains event dates for that month. Adapt the solution for July 2022.

---

## Solution

```sql


WITH FIRST_CTE AS (
  SELECT DISTINCT user_id 
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = 2022
    AND EXTRACT(MONTH FROM event_date) = 7
    AND event_type IN ('sign-in', 'like', 'comment')
), 

SECOND_CTE AS (
  SELECT DISTINCT user_id
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = 2022
    AND EXTRACT(MONTH FROM event_date) = 6
    AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT 
  7 AS month, 
  COUNT(f.user_id) AS monthly_active_users
FROM FIRST_CTE f
JOIN SECOND_CTE s 
  ON f.user_id = s.user_id;
