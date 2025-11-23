-- 262. Trips and Users

-- Table: Trips
-- id (int)
-- client_id (int)
-- driver_id (int)
-- city_id (int)
-- status (enum)
-- request_at (varchar)

-- Table: Users
-- users_id (int)
-- banned (enum)
-- role (enum)

-- Task:
-- Find the daily cancellation rate of requests where both client and driver are not banned
-- for each day between "2013-10-01" and "2013-10-03" (inclusive) with at least one trip.
-- Cancellation rate = (number of cancelled trips) / (total trips)
-- Round the cancellation rate to two decimal points.
-- Return results as "Day" and "Cancellation Rate" in any order.

WITH first_cte AS (
    SELECT  
        t.request_at AS request_at,  
        (SUM(CASE WHEN t.status NOT IN ('completed') THEN 1 ELSE 0 END) * 1.0) /  
        SUM(CASE WHEN t.status IN ('completed', 'cancelled_by_driver', 'cancelled_by_client') THEN 1 ELSE 0 END) AS cancellation_rate  
    FROM Trips t  
    JOIN Users u ON t.client_id = u.users_id  
    JOIN Users uu ON t.driver_id = uu.users_id  
    WHERE u.banned = 'No' AND uu.banned = 'No'  
      AND t.request_at BETWEEN '2013-10-01' AND '2013-10-03'  
    GROUP BY t.request_at  
)  
SELECT  
    request_at AS 'Day',  
    ROUND(cancellation_rate, 2) AS 'Cancellation Rate'  
FROM first_cte;
