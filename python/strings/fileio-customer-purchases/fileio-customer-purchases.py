purchases = [
    ("Alice", "Laptop", 1200),
    ("Bob", "Mouse", 25),
    ("Alice", "Keyboard", 70),
    ("Charlie", "Monitor", 300),
    ("Bob", "Tablet", 500),
]

file = open('purchases.txt', 'w')

for customer, item, price in purchases:
    file.write(f'Customer: {customer}, Item: {item}, Price: {price}\n')
file.close()

groups = {}

with open('purchases.txt', 'r') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue

        # Split into parts and directly build dict
        parts = dict(p.split(':', 1) for p in line.split(', '))

        customer = parts['Customer'].strip()
        price = float(parts['Price'].strip())

        if customer not in groups:
            groups[customer] = 0.0
        groups[customer] += price

for customer, total in groups.items(): 
    print(f'{customer} -> {total}')










