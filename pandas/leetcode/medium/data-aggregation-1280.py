'''
1280. Students and Examinations
Table: Students
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one student in the school.
 

Table: Subjects
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key (column with unique values) for this table.
Each row of this table contains the name of one subject in the school.
 

Table: Examinations
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

Write a solution to find the number of times each student attended each exam.
Return the result table ordered by student_id and subject_name.
The result format is in the following example. 
'''

import pandas as pd
def students_and_examinations(students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame) -> pd.DataFrame:

    # Step 1: Create a cartesian product of students and subjects to count null values as well later 
    student_subject_df = students.assign(key=1).merge(subjects.assign(key=1), on='key').drop('key', axis=1)

    # Step 2: Count exam attendances
    attendance_df = examinations.groupby(['student_id', 'subject_name']).size().reset_index(name='attended_exams')

    # Step 3: Merge it with the cartesian product to get all combinations
    result = pd.merge(student_subject_df, attendance_df, on=['student_id', 'subject_name'], how='left')

    # Step 4: Fill NaNs with 0 to count the zeros
    result['attended_exams'] = result['attended_exams'].fillna(0).astype(int)

    # Step 5: Sorting and returning final df output
    return result.sort_values(['student_id', 'subject_name']).reset_index(drop=True)



# Alternate and easier to follow method using cross join 
import pandas as pd 

def students_and_examinations(students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Creating cartesian product using this method of how='cross'
    student_subject_df = pd.merge(students, subjects, how='cross')

    # Step 2–5 remain the same
    attendance_df = examinations.groupby(['student_id', 'subject_name']).size().reset_index(name='attended_exams')
    result = pd.merge(student_subject_df, attendance_df, on=['student_id', 'subject_name'], how='left')
    result['attended_exams'] = result['attended_exams'].fillna(0).astype(int)
    return result.sort_values(['student_id', 'subject_name']).reset_index(drop=True)
