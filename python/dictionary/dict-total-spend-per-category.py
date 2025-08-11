purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Bob", "Tablet", "Electronics", 500),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("David", "Soap", "Personal Care", 3),
    ("Eve", "Pen", "Stationery", 2),
    ("Eve", "Notebook", "Stationery", 5)
]


groups = {}

for customer, item, category, price in purchases: 
	if category not in groups: 
		groups[category] =[]
	groups[category].append(price)
	
total_spend = {}

for category, price in groups.items(): 
	total_spend[category] = sum(price)
	
print(total_spend)

# simpler code with default dict

from collections import defaultdict

total_spend = defaultdict(int)

for customer, item, category, price in purchases:
    total_spend[category] += price

print(dict(total_spend))
