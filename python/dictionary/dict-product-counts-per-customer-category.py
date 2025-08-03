purchases = [
    ("Alice", "Laptop", "Electronics"),
    ("Bob", "Mouse", "Electronics"),
    ("Alice", "Keyboard", "Electronics"),
    ("Charlie", "Shampoo", "Personal Care"),
    ("Alice", "Notebook", "Stationery"),
    ("Bob", "Tablet", "Electronics"),
    ("Charlie", "Toothpaste", "Personal Care"),
    ("Alice", "Pen", "Stationery"),
    ("Bob", "Monitor", "Electronics"),
    ("Charlie", "Soap", "Personal Care"),
]


groups = {}

for customer, item, category in purchases: 
   
   if customer not in groups: 
     groups[customer] = {}

   if category not in groups[customer]:
     groups[customer][category] = 0
   groups[customer][category] += 1

print(groups)



# alternate solution using defaultdict for cleaner code


from collections import defaultdict

# Step 1: Initialize nested defaultdict
groups = defaultdict(lambda: defaultdict(int))

# Step 2: Loop through purchases and count
for customer, item, category in purchases:
    groups[customer][category] += 1

# Step 3: (Optional) Convert to regular dict for clean printing
result = {customer: dict(categories) for customer, categories in groups.items()}
print(result)
