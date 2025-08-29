'''
196. Delete Duplicate Emails

Table: Person

id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.

Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

'''

import pandas as pd

def delete_duplicate_emails(person: pd.DataFrame) -> None:
    person.sort_values(by='id', ascending=True, inplace=True)
    person.drop_duplicates(subset='email', keep='first', inplace=True)

