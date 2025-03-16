Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

Definition:

action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.
emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
433	1052	07/09/2022 00:00:00
texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	datetime


SOLUTION: 


WITH FIRST_CTE AS (
  SELECT e.email_id as email_id, 
  e.user_id as user_id, 
  e.signup_date as signup_date,
  t.signup_action as signup_action,
  t.action_date as action_date
  FROM texts t 
  JOIN emails e 
  ON e.email_id = t.email_id
)

SELECT user_id
FROM FIRST_CTE
WHERE action_date = signup_date + INTERVAL '1 DAY'
AND signup_action = 'Confirmed'; 