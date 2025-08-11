purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Bob", "Mouse", "Electronics", 25),
    ("Bob", "Tablet", "Electronics", 500),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("David", "Soap", "Personal Care", 3)
]


# For each **customer** and **category**, calculate their **average spend per purchase**.


groups = {}

for customer, item, category, price in purchases: 
	if customer not in groups: 
		groups[customer] =  {}
	if category not in groups[customer]:
		groups[customer][category] = []
	groups[customer][category].append(price)
	
print(groups)

average_spend = {}

average_spend = {}

for customer in groups:
    for category in groups[customer]:
        prices = groups[customer][category]
        average_spend[(customer, category)] = sum(prices) / len(prices)

print(average_spend)