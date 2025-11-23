#### QUESTION & ANSWER 

-- 197. Rising Temperature

-- Table: Weather
-- id (unique key)
-- recordDate (date, unique per row)
-- temperature (int)

-- Task:
-- Find all dates' id where the temperature is higher than the previous day's temperature.
-- Return results in any order.

-- MySQL Query
SELECT 
    w.id
FROM Weather w
JOIN Weather ww
    ON DATEDIFF(w.recordDate, ww.recordDate) = 1
WHERE w.temperature > ww.temperature;
