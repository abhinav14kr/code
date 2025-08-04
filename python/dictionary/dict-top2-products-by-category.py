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
        groups[category][item] = 0
    groups[category][item] += 1




top_customer = {}
for category, items in groups.items():
    top_2 = sorted(items.items(), key=lambda x: x[1], reverse=True)[:2]
    top_customer[category] = [item for item, count in top_2]

print(top_customer)
