-- 1112. Highest Grade For Each Student
-- Difficulty: Medium
-- Tag: SQL

-- Table: Enrollments
-- student_id, course_id (composite primary key)
-- grade (never NULL)

-- Task:
-- For each student, return the highest grade and its corresponding course.
-- If multiple courses share the same highest grade, return the one with the smallest course_id.
-- Order results by student_id ASC.

-- MySQL Query
WITH FIRST_CTE AS (
    SELECT 
        *, 
        DENSE_RANK() OVER (
            PARTITION BY student_id 
            ORDER BY grade DESC, course_id ASC
        ) AS ranked
    FROM Enrollments
)
SELECT 
    student_id, 
    course_id, 
    grade
FROM FIRST_CTE
WHERE ranked = 1;
