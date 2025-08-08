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

from collections import defaultdict

item_counts = defaultdict(int)

for customer, item, category, price in purchases:
    item_counts[item] += 1

top_3 = sorted(item_counts.items(), key=lambda x: x[1], reverse=True)[:3]

print(top_3)
