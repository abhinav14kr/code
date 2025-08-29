'''
1527.  
Patients With a Condition
Table: Patients

patient_id is the primary key (column with unique values) for this table.
'conditions' contains 0 or more code separated by spaces. 
This table contains information of the patients in the hospital.
 
Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.
Return the result table in any order.

'''
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    df_filtered = patients[patients['conditions'].str.contains(r'(^|\s)DIAB1', na=False)]
    return df_filtered

    