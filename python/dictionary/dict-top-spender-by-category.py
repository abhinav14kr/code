purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Bob", "Mouse", "Electronics", 25),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Charlie", "Shampoo", "Personal Care", 15),
    ("David", "Soap", "Personal Care", 5),
    ("Charlie", "Toothpaste", "Personal Care", 7),
    ("Eve", "Pen", "Stationery", 3),
    ("Alice", "Notebook", "Stationery", 10),
    ("Frank", "Marker", "Stationery", 2),
    ("Eve", "Monitor", "Electronics", 200),
    ("Bob", "Tablet", "Electronics", 300),
    ("David", "Deodorant", "Personal Care", 8),
]


groups = {}  # category -> {customer -> total_spent}

for customer, item, category, price in purchases:
    if category not in groups:
        groups[category] = {}

    if customer not in groups[category]:
        groups[category][customer] = 0

    groups[category][customer] += price


print(groups)


results = {}

for category, customer_spend in groups.items():
    top_customer = max(customer_spend, key=customer_spend.get)
    results[category] = top_customer

print(results)










# with defaultdict for cleaner code

from collections import defaultdict

groups = defaultdict(lambda: defaultdict(int))

for customer, item, category, price in purchases:
    groups[category][customer] += price

results = {}

for category, customer_spending in groups.items():
    top_customer = max(customer_spending, key=customer_spending.get)
    results[category] = top_customer

print(results)
