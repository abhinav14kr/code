purchases = [
    ("Alice", "Laptop", "Electronics"),
    ("Bob", "Mouse", "Electronics"),
    ("Alice", "Keyboard", "Electronics"),
    ("Charlie", "Shampoo", "Personal Care"),
    ("Alice", "Notebook", "Stationery"),
    ("Bob", "Tablet", "Electronics"),
    ("Charlie", "Toothpaste", "Personal Care"),
    ("Alice", "Pen", "Stationery"),
    ("Bob", "Monitor", "Electronics"),
    ("Charlie", "Soap", "Personal Care"),
    ("Alice", "Phone Case", "Electronics"),
    ("Bob", "Stapler", "Stationery"),
    ("Charlie", "Notebook", "Stationery"),
]


groups = {}

for customer, items, category in purchases:
    if customer not in groups: 
        groups[customer] = {}


    if category not in groups[customer]:
        groups[customer][category] = 0
    groups[customer][category] += 1

print(groups)

result = {customer: max(categories.items(), key=lambda x: x[1])[0] 
          for customer, categories in groups.items() if categories}

print(result)



# Alternate solution using defaultdict for cleaner code


from collections import defaultdict

# Step 1: Group counts by customer and category
groups = defaultdict(lambda: defaultdict(int))

for customer, item, category in purchases:
    groups[customer][category] += 1

result = {}

for customer, category_counts in groups.items():
    top_category = max(category_counts, key=category_counts.get)
    result[customer] = top_category

print(result)


