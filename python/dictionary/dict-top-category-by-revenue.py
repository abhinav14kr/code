purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Bob", "Mouse", "Electronics", 25),
    ("Alice", "Keyboard", "Electronics", 45),
    ("Charlie", "Shampoo", "Personal Care", 5),
    ("David", "Soap", "Personal Care", 3),
    ("Charlie", "Toothpaste", "Personal Care", 4),
    ("Eve", "Pen", "Stationery", 1),
    ("Frank", "Notebook", "Stationery", 2),
    ("Eve", "Monitor", "Electronics", 200),
]


groups = {}

for customer, item, category, price in purchases: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(item)

print(groups)


total_revenue = {}

for customer, item, category, price in purchases:
    if category not in total_revenue: 
        total_revenue[category] = 0 
    total_revenue[category] += price

print(total_revenue)

highest_revenue = {}

for category, price in total_revenue.items(): 
    if price == max(total_revenue.values()):
        print(f"Top category by revenue: {category}: ${price}")
