# Facebook Pages with Zero Likes - SQL Interview Question

**Source:** Facebook SQL Interview Question

---

## Problem Statement

Assume you are given two tables containing data about Facebook Pages and their respective likes.  

Write a query to return the **IDs of the Facebook pages that have zero likes**. The output should be **sorted in ascending order** based on the `page_id`.

---

## Tables

### Table: `pages`

| Column Name | Type    |
|------------|---------|
| page_id    | integer |
| page_name  | varchar |

**Example Input:**

| page_id | page_name           |
|---------|-------------------|
| 20001   | SQL Solutions      |
| 20045   | Brain Exercises    |
| 20701   | Tips for Data Analysts |

---

### Table: `page_likes`

| Column Name | Type     |
|------------|----------|
| user_id    | integer  |
| page_id    | integer  |
| liked_date | datetime |

**Example Input:**

| user_id | page_id | liked_date          |
|---------|---------|-------------------|
| 111     | 20001   | 04/08/2022 00:00:00 |
| 121     | 20045   | 03/12/2022 00:00:00 |
| 156     | 20001   | 07/25/2022 00:00:00 |

---

## Example Output

| page_id |
|---------|
| 20701   |

> Note: The dataset you are querying against may have different input & output — this is just an example.

---

## Solution

```sql
WITH first_cte AS (
  SELECT 
    p.page_id,
    COUNT(l.user_id) AS counts
  FROM pages p
  LEFT JOIN page_likes l
    ON p.page_id = l.page_id
  GROUP BY p.page_id
  HAVING COUNT(l.user_id) = 0
)
SELECT page_id
FROM first_cte
ORDER BY page_id;
