import re

def extract_currency(text):
    #  currency finder using regex
    pattern = r'\$\d+(?:\.\d+)?|€\d+(?:\.\d+)?|£\d+(?:\.\d+)?|INR \d+(?:\.\d+)?'
    currency = re.findall(pattern, text)

    # Removing duplicates (using set) and sorting
    unique_currency = sorted(set(currency))

    # Saving to file
    with open('currencies.txt', 'w') as f:
        for currency in unique_currency:
            f.write(currency + '\n')

    return unique_currency

text = """
The new phone costs $999, while the laptop is €1200.50. 
I also spent £75 on accessories and INR 1500 on software.
"""

print(extract_currency(text))