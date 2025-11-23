#### QUESTION & ANSWER 

-- 196. Delete Duplicate Emails

-- Table: Person
-- id (primary key)
-- email (varchar, lowercase, no uppercase)

-- Task:
-- Delete all duplicate emails.
-- Keep only the row with the smallest id for each email.
-- You must write a DELETE statement (not SELECT).
-- Final order of the Person table does not matter.

-- MySQL Query
WITH ranked AS (
    SELECT 
        id, 
        ROW_NUMBER() OVER (
            PARTITION BY email 
            ORDER BY id
        ) AS row_num
    FROM Person
)
DELETE FROM Person
WHERE id IN (
    SELECT id 
    FROM ranked 
    WHERE row_num > 1
);
