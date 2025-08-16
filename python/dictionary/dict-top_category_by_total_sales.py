purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Mouse", "Electronics", 25),
    ("Alice", "Shampoo", "Personal Care", 15),
    ("Bob", "Tablet", "Electronics", 300),
    ("Bob", "Notebook", "Stationery", 5),
    ("Bob", "Pen", "Stationery", 3),
    ("Charlie", "Soap", "Personal Care", 10),
    ("Charlie", "Toothpaste", "Personal Care", 7),
    ("Charlie", "Headphones", "Electronics", 50)
]

groups = {}

for name, item, category, price in purchases: 
    if name not in groups: 
        groups[name] = {}
    if category not in groups[name]:
        groups[name][category] = []
    groups[name][category].append((item, price))

print(groups)

total_spending = {}

for name, categories in groups.items():
    total_spending[name] = {category: sum(price for item, price in items) 
                            for category, items in categories.items()}

print(total_spending)

most_spent_category = {}

for name, categories in total_spending.items():
    most_spent_category[name] = max(categories, key=categories.get)

print(most_spent_category)


# alternate way to do it  with default dict 

from collections import defaultdict

# Step 1: Nested defaultdict to store sums directly
groups = defaultdict(lambda: defaultdict(int))

for name, item, category, price in purchases:
    groups[name][category] += price  # directly add to the total

# Step 2: Find the top category per customer
most_spent_category = {
    name: max(category_totals, key=category_totals.get)
    for name, category_totals in groups.items()
}

print(dict(most_spent_category))

