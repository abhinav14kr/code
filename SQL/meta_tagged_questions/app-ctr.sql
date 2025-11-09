# 📱 App Click-through Rate (CTR) - Facebook SQL Interview Question

**Source:** Same as Problem #1 in the SQL Chapter of *Ace the Data Science Interview*

---

## 📝 Problem Statement

Assume you have an `events` table containing Facebook app analytics.  
Write a SQL query to calculate the **Click-Through Rate (CTR)** for each app in **2022**, and round the results to **2 decimal places**.
---

## Table: `events`

| Column Name | Type     |
|------------|----------|
| app_id     | integer  |
| event_type | string   |
| timestamp  | datetime |

---

## Example Input

| app_id | event_type  | timestamp           |
|--------|-------------|-------------------|
| 123    | impression  | 07/18/2022 11:36:12 |
| 123    | impression  | 07/18/2022 11:37:12 |
| 123    | click       | 07/18/2022 11:37:42 |
| 234    | impression  | 07/18/2022 14:15:12 |
| 234    | click       | 07/18/2022 14:16:12 |

---

## Example Output

| app_id | ctr   |
|--------|-------|
| 123    | 50.00 |
| 234    | 100.00 |

---

## Explanation

For **App 123**:  
- Impressions = 2  
- Clicks = 1  
- CTR = (1 / 2) * 100.0 = 50.00%

For **App 234**:  
- Impressions = 1  
- Clicks = 1  
- CTR = (1 / 1) * 100.0 = 100.00%

---

## Solution

```sql
SELECT
  app_id,
  ROUND(
    100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END),
    2
  ) AS ctr
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = 2022
GROUP BY app_id
ORDER BY app_id DESC;
