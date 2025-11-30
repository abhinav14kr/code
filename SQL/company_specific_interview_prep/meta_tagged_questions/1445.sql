-- 1445. Apples & Oranges

-- Table: Sales
-- sale_date (date)
-- fruit (enum: 'apples', 'oranges')
-- sold_num (int)
-- (sale_date, fruit) is the primary key.
-- Each row contains the number of apples or oranges sold on a given day.

-- Goal:
-- For each day, report the difference between the number of apples sold and oranges sold.
-- Return results ordered by sale_date.

-- MySQL Query

WITH FIRST_CTE AS (
    -- Sales of apples
    SELECT 
        sale_date,
        sold_num
    FROM Sales
    WHERE fruit = 'apples'
), 

SECOND_CTE AS (
    -- Sales of oranges
    SELECT 
        sale_date,
        sold_num
    FROM Sales
    WHERE fruit = 'oranges'
)

SELECT 
    f.sale_date,
    f.sold_num - s.sold_num AS diff
FROM FIRST_CTE f
JOIN SECOND_CTE s
    ON f.sale_date = s.sale_date
ORDER BY f.sale_date;
