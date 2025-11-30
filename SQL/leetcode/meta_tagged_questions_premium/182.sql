-- 182. Duplicate Emails

-- Table: Person
-- id (primary key)
-- email (lowercase, never NULL)
--
-- Task:
-- Report all duplicate emails.
-- Return results in any order.

-- MySQL Query
WITH FIRST_CTE AS (
    SELECT 
        email, 
        COUNT(*) AS counts
    FROM Person
    GROUP BY email
    HAVING COUNT(*) > 1
)
SELECT 
    email AS Email
FROM FIRST_CTE;
