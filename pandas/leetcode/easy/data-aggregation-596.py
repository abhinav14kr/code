'''

596. Classes With at Least 5 Students
Table: Courses

(student, class) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.
 
Write a solution to find all the classes that have at least five students.
Return the result table in any order.
The result format is in the following example.

'''

import pandas as pd

def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    filtered_df = courses.groupby('class')['student'].count().reset_index()
    result = filtered_df[(filtered_df['student'] >= 5)]
    return result[['class']]