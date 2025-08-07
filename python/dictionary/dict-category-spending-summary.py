purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Bob", "Mouse", "Electronics", 25),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("Alice", "Notebook", "Stationery", 5),
    ("Bob", "Tablet", "Electronics", 500),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("David", "Soap", "Personal Care", 3),
    ("Charlie", "Notebook", "Stationery", 7),
    ("Eve", "Pen", "Stationery", 2)
]

groups = {}

for customers, item, category, price in purchases: 
    if category not in groups: 
        groups[category] = {}
    if customers not in groups[category]:
        groups[category][customers] = 0
    groups[category][customers] += price

print(groups)

results = {}

for category, customers in groups.items():
    total_spending = sum(customers.values())
    unique_customers = len(customers)
    results[category] = {
        "total_spending": total_spending,
        "unique_customers": unique_customers
    }

print(results)
