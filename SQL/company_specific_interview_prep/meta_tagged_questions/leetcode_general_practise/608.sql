-- 608. Tree Node

-- Table: Tree
-- id (int)      -- unique
-- p_id (int)    -- parent id, NULL for root

-- Task:
-- Classify each node in the tree as:
--   • 'Root'  → p_id IS NULL
--   • 'Inner' → node has children (id appears as a p_id somewhere)
--   • 'Leaf'  → otherwise (no children, not root)
--
-- Return the result in any order.

-- MySQL Query

SELECT 
    id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree;
