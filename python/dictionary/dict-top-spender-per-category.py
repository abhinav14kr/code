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

top_spenders = {}

for customers, items, category, price in purchases: 
    if category not in top_spenders: 
        top_spenders[category] = {}
    if customers not in top_spenders[category]:
        top_spenders[category][customers] = 0
    top_spenders[category][customers] += price

print(top_spenders)

for category, items in top_spenders.items():
    top_spender = max(items.items(), key=lambda x: x[1])
    print(f"Category: {category}, Top Spender: {top_spender[0]}")
