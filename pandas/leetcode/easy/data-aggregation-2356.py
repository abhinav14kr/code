'''

2356. Number of Unique Subjects Taught by Each Teacher
Table: Teacher

(subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.
 

Write a solution to calculate the number of unique subjects each teacher teaches in the university.
Return the result table in any order.
The result format is shown in the following example.

'''


import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    teacher['cnt'] = teacher.groupby('teacher_id')['subject_id'].transform('nunique')
    result = teacher[['teacher_id', 'cnt']].drop_duplicates()   

    return result