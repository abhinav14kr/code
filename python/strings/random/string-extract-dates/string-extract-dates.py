import re
import datefinder

text = """
Project kickoff: 2025-08-27  
Final review: 15/09/2025  
Deployment planned: 2025-10-01
"""
matches = list(datefinder.find_dates(text))  # Convert generator to list

normalized_dates = [date.strftime("%Y-%m-%d") for date in matches]


print(normalized_dates)

length = len(normalized_dates)
print(f"Total dates found: {length}")

with open('dates.txt', 'w') as f:
    for date in normalized_dates:
        print(f'{date}', file=f)