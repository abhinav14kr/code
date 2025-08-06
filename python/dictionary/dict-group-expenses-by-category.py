expenses = [
    ("food", 12.5),
    ("transport", 8.0),
    ("food", 7.5),
    ("utilities", 30.0),
    ("transport", 5.0)
]


groups = {}

for category, price in expenses: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(price)
    
print(groups)

sums = {}

for category, price in groups.items():
    sums[category] = sum(price)  

print(sums)
