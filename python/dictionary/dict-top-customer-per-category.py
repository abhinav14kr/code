purchases = [
    ("Alice", "Laptop", "Electronics"),
    ("Bob", "Mouse", "Electronics"),
    ("Alice", "Keyboard", "Electronics"),
    ("Charlie", "Shampoo", "Personal Care"),
    ("David", "Soap", "Personal Care"),
    ("Charlie", "Toothpaste", "Personal Care"),
    ("Eve", "Pen", "Stationery"),
    ("Alice", "Notebook", "Stationery"),
    ("Frank", "Marker", "Stationery"),
    ("Eve", "Monitor", "Electronics"),
    ("Bob", "Tablet", "Electronics"),
    ("Charlie", "Notebook", "Stationery"),
    ("Alice", "Laptop", "Electronics"),
    ("Eve", "Pen", "Stationery"),
    ("David", "Shampoo", "Personal Care"),
]

groups = {}

for customer, item, category in purchases: 
	if category not in groups: 
		groups[category] = {}
	if item not in groups[category]: 
		groups[category][customer] = 0 
	groups[category][customer] += 1 

print(groups)

top_customer = {}

for category, customer in groups.items(): 
	top_customer[category] = max(customer, key=customer.get)

print(top_customer)


# with defaultdict for cleaner code taken from chatgpt 

from collections import defaultdict

# Nested defaultdict: category → customer → count
groups = defaultdict(lambda: defaultdict(int))

# Count purchases per customer per category
for customer, item, category in purchases:
    groups[category][customer] += 1

# Find the most loyal customer per category
top_customer = {
    category: max(customers, key=customers.get)
    for category, customers in groups.items()
}

print(top_customer)
