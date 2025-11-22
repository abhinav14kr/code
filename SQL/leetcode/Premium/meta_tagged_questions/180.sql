-- 180. Consecutive Numbers

-- Table: Logs
-- id (int, primary key, auto-increment)
-- num (varchar)
--
-- Task:
-- Find all numbers that appear at least three times consecutively.
-- Return results in any order.

-- MySQL Query
SELECT DISTINCT 
    a.num AS ConsecutiveNums
FROM Logs a
JOIN Logs b 
    ON a.id = b.id + 1
JOIN Logs c 
    ON b.id = c.id + 1
WHERE a.num = b.num
  AND b.num = c.num;
