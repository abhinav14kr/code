import re
import datefinder

text = """
Call me at 123-456-7890 or (987) 654-3210.
For international queries, dial +1-555-234-5678 or just 5551234567.
"""


def extract_phone_numbers(text):
    clean = text.strip()
    clean = clean.lower()
    print(clean)

    pattern = r'(\+\d{1,3}-\d{3}-\d{3}-\d{4}|\(\d{3}\) \d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\b\d{10}\b)'
    phone_numbers = re.findall(pattern, clean)
    print(phone_numbers)


    unique_numbers = set(phone_numbers)
    print(unique_numbers)

    def standardize_number(num):
        digits = re.sub(r'\D', '', num)  # Remove all non-digit characters
        if len(digits) == 11 and digits.startswith('1'):
            digits = digits[1:]  # Strip leading '1'
        elif len(digits) == 10:
            pass
        else:
            return None  # Invalid number
        return f'+1-{digits[:3]}-{digits[3:6]}-{digits[6:]}'

    standardized_numbers = set()
    for match in unique_numbers:
        std = standardize_number(match)
        if std:
            standardized_numbers.add(std)
            
    print(standardized_numbers)



    with open('phones.txt', 'w') as f:
        for number in standardized_numbers:
            print(f'{number}', file=f)

    return phone_numbers

extract_phone_numbers(text)