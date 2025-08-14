purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Bob", "Mouse", "Electronics", 25),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("David", "Soap", "Personal Care", 3),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("Eve", "Pen", "Stationery", 2),
    ("Alice", "Notebook", "Stationery", 5),
    ("Frank", "Marker", "Stationery", 3),
    ("Eve", "Monitor", "Electronics", 200),
    ("Bob", "Tablet", "Electronics", 500)
]


groups = {}

for customer, item, category, price in purchases:
     if customer not in groups: 
          groups[customer] = 0
     groups[customer] += price    

print(groups)

top_3 = sorted(groups.items(), key=lambda x: x[1], reverse=True)[:3]

print(top_3)
