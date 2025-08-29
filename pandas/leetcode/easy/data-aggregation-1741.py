'''

1741. Find Total Time Spent by Each Employee
Table: Employees

(emp_id, event_day, in_time) is the primary key (combinations of columns with unique values) of this table.
The table shows the employees' entries and exits in an office.
event_day is the day at which this event happened, in_time is the minute at which the employee entered the office, and out_time is the minute at which they left the office.
in_time and out_time are between 1 and 1440.
It is guaranteed that no two events on the same day intersect in time, and in_time < out_time.

Write a solution to calculate the total time in minutes spent by each employee on each day at the office. Note that within one day, an employee can enter and leave more than once. The time spent in the office for a single entry is out_time - in_time.
Return the result table in any order.
The result format is in the following example.

'''

import pandas as pd

def total_time(employees: pd.DataFrame) -> pd.DataFrame:

    # Renaming 'event_day' to 'day' coz that's the expected output format from leetcode
    employees = employees.rename(columns={'event_day': 'day'})
    
    # Calculating  total time spent in the office
    employees['total_time'] = employees['out_time'] - employees['in_time']
    
    # Grouping by 'day' and 'emp_id', sum the total time spent, sorting by 'emp_id'
    result = employees.groupby(['day', 'emp_id'])['total_time'].sum().reset_index().sort_values(by='emp_id', ascending=True)
    
    return result
