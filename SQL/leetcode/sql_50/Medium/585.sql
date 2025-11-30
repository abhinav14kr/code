'''
585. Investments in 2016

Table: Insurance
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key (column with unique values) for this table.
Each row of this table contains information about one policy where:
pid is the policyholders policy ID.
tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holders city. Its guaranteed that lat is not NULL.
lon is the longitude of the policy holders city. Its guaranteed that lon is not NULL.

'''


SOLUTION: 


# Write your MySQL query statement below
SELECT ROUND(SUM(tiv_2016),2) as tiv_2016
FROM Insurance 
WHERE tiv_2015 IN 
    (SELECT tiv_2015
    FROM Insurance 
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
    )
AND 
    (lat,lon) IN (
        SELECT lat, lon
        FROM Insurance
        GROUP BY 1,2
        HAVING COUNT(*) = 1
    ); 