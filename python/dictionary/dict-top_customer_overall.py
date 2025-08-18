purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Mouse", "Electronics", 25),
    ("Bob", "Tablet", "Electronics", 300),
    ("Bob", "Notebook", "Stationery", 5),
    ("Charlie", "Shampoo", "Personal Care", 15),
    ("Charlie", "Toothpaste", "Personal Care", 7),
    ("Charlie", "Headphones", "Electronics", 50),
]

total_spent = {}

for customer, item, category, price in purchases: 
    if customer not in total_spent:
        total_spent[customer] = 0 
    total_spent[customer] += price
	
print(total_spent)

top_customer = max(total_spent, key = total_spent.get)
print(f"Top customer: {top_customer}, Total_spent: {total_spent[top_customer]}")


# with default dict 

from collections import defaultdict

total_spent = defaultdict(int)

for customer, item, category, price in purchases:
    total_spent[customer] += price

top_customer = max(total_spent, key=total_spent.get)
print(f"Top Customer: {top_customer}, Total Spent: {total_spent[top_customer]}")


