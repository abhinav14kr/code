-- 1264. Page Recommendations

-- Tables:
-- Friendship
--   user1_id (int)
--   user2_id (int)
--   → (user1_id, user2_id) is the PK
--   → Represents a bidirectional friendship

-- Likes
--   user_id (int)
--   page_id (int)
--   → (user_id, page_id) is the PK
--   → Each row indicates a user likes a page

-- Goal:
-- Recommend pages to user_id = 1 based on pages liked by their friends.
-- Do NOT recommend pages the user already likes.
-- Return unique page_id results in any order.

-- MySQL Query

WITH All_Friendships AS (
    -- All friendships involving user 1
    SELECT 
        user1_id, 
        user2_id
    FROM Friendship
    WHERE user1_id = 1 OR user2_id = 1
),

Friends_List AS (
    -- Normalize to a clean list of friend_ids
    SELECT user2_id AS friend_id
    FROM All_Friendships
    WHERE user1_id = 1
    UNION
    SELECT user1_id AS friend_id
    FROM All_Friendships
    WHERE user2_id = 1
)

SELECT DISTINCT
    l.page_id AS recommended_page
FROM Friends_List f
JOIN Likes l
    ON f.friend_id = l.user_id
WHERE l.page_id NOT IN (
    -- Exclude pages already liked by user 1
    SELECT page_id
    FROM Likes
    WHERE user_id = 1
);
