import re
import datefinder

text = """
Call me at 123-456-7890 or (987) 654-3210.
For international queries, dial +1-555-234-5678 or just 5551234567.
"""


clean = text.strip()
clean = clean.lower()
print(clean)

phone = re.match(r"^(\([0-9]{3}\) ?|[0-9]{3}-)[0-9]{3}-[0-9]{4}$", clean)
print(phone)
