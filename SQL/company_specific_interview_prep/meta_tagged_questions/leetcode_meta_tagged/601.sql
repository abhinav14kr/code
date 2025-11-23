-- 601. Human Traffic of Stadium

-- Table: Stadium
-- id (int)
-- visit_date (date)   -- unique
-- people (int)
-- As id increases, visit_date increases.

-- Task:
-- Find all records that are part of a group of **three or more consecutive ids**
-- where **each row has people >= 100**.
-- Return the result ordered by visit_date ASC.
--
-- Logic:
-- We check every row to see if it is part of ANY group of 3 consecutive ids:
--   (id, id+1, id+2) or (id-1, id, id+1) or (id-2, id-1, id)
-- All must have people >= 100.

-- MySQL Query

SELECT DISTINCT s1.*
FROM Stadium s1, Stadium s2, Stadium s3
WHERE s1.people >= 100 
  AND s2.people >= 100 
  AND s3.people >= 100
  AND (
        (s1.id = s2.id - 1 AND s1.id = s3.id - 2)   -- s1 is first in sequence
     OR (s1.id = s2.id + 1 AND s1.id = s3.id - 1)   -- s1 is middle
     OR (s1.id = s2.id + 2 AND s1.id = s3.id + 1)   -- s1 is last
  )
ORDER BY visit_date ASC;
