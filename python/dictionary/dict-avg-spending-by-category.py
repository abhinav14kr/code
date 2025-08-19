purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Bob", "Mouse", "Electronics", 40),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("David", "Soap", "Personal Care", 5),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("Eve", "Pen", "Stationery", 2),
    ("Alice", "Notebook", "Stationery", 5),
    ("Frank", "Marker", "Stationery", 3),
    ("Eve", "Monitor", "Electronics", 300),
    ("Bob", "Tablet", "Electronics", 250),
]


groups = {}

for customer, item, category, price in purchases: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(price)

# averages = {category: sum(price) / len(price) for category, price in groups.items()}

average_spending = {}

for category, price in groups.items(): 
    average_spending[category] = sum(price) / len(price)

for category, average in average_spending.items():
    print(f'Category: {category} -> Average Spending: {average:.2f}')


#