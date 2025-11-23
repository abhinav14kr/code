-- 578. Get Highest Answer Rate Question

-- Table: SurveyLog
-- id (int)
-- action (enum: 'show', 'answer', 'skip')
-- question_id (int)
-- answer_id (int or null)
-- q_num (int)
-- timestamp (int)

-- Task:
-- The answer rate for a question = (# answered) / (# showed)
-- Find the question with the highest answer rate.
-- If multiple questions tie, choose the one with the smallest question_id.
-- Return the result as a single column named "survey_log".

-- MySQL Query

WITH first_cte AS (
    SELECT 
        question_id,
        SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) AS num_showed
    FROM SurveyLog
    GROUP BY question_id
),

second_cte AS (
    SELECT 
        f.question_id,
        SUM(CASE WHEN s.action = 'answer' THEN 1 ELSE 0 END) AS num_answered
    FROM SurveyLog s
    JOIN first_cte f 
        ON f.question_id = s.question_id
    GROUP BY f.question_id
),

third_cte AS (
    SELECT 
        f.question_id,
        1.0 * s.num_answered / f.num_showed AS answer_rate
    FROM first_cte f
    JOIN second_cte s 
        ON f.question_id = s.question_id
    ORDER BY answer_rate DESC, question_id ASC
)

SELECT 
    question_id AS survey_log
FROM third_cte
LIMIT 1;


