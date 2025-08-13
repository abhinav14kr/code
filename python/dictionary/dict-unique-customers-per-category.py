purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Bob", "Tablet", "Electronics", 500),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("David", "Soap", "Personal Care", 3),
    ("Eve", "Pen", "Stationery", 2),
    ("Alice", "Notebook", "Stationery", 5)
]


groups = {}

for customer, item, category, price in purchases: 
	if category not in groups: 
		groups[category] = []
	groups[category].append(customer)

print(groups)

unique_customers = {}

for category, customers in groups.items(): 
	unique_customers[category] = len(set(customers))

print(unique_customers)
