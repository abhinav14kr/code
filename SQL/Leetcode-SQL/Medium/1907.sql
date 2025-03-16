1907. Count Salary Categories

Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.
 

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.


SOLUTION: 


WITH FIRST_CTE AS (
    Select 'Low Salary' as Category
    UNION
    SELECT 'Average Salary'
    UNION
    SELECT 'High Salary'
),

SECOND_CTE AS (
    SELECT
    CASE 
        WHEN income < 20000 THEN 'Low Salary'
        WHEN income >= 20000 AND income <= '50000' THEN 'Average Salary'
        WHEN income > 50000 THEN 'High Salary'
    END AS Category 
FROM Accounts
)

SELECT c.Category, count(s.category) as accounts_count
FROM FIRST_CTE C
LEFT JOIN SECOND_CTE S 
on c.Category = s.Category
GROUP BY c.Category; 


 