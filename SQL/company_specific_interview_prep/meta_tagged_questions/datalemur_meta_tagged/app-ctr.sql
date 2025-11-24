-- App Click-through Rate (CTR) — Facebook SQL Interview Question
-- Problem Source: Ace the Data Science Interview (SQL Chapter #1)

-- Table: events
-- app_id (int)
-- event_type (varchar)      -- 'impression', 'click'
-- timestamp (datetime)
--
-- Goal:
-- Compute Click-Through Rate (CTR) for each app in 2022.
-- Definition:
--     CTR = (clicks / impressions) * 100
--     Round result to 2 decimal places.
--
-- Return:
-- app_id, ctr (numeric, rounded to 2 decimals)


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
ORDER BY app_id;
