# my solution 

with open('purchases.txt') as f:
    lines = f.readlines()
    print(lines)

    groups = {}

    for line in lines:
        name, item, price = line.strip().split(',')
        if name not in groups:
            groups[name] = []
        groups[name].append(price)

    print(groups)


    result = {}

    for name, prices in groups.items():
        total = 0 
        for v in prices: 
            total += int(v)
        result[name] = total

    for name, total in result.items():
        print(f'{name} -> {total}')



with open('totals.txt', 'w') as f:
    for name, total in result.items():
        print(f'{name} -> {total}', file=f)




# copilots crisp version of the solution (scalable for larger files)

# fileio-purchase-summary.py

totals = {}

with open('purchases.txt') as f:
    for line in f:
        if not line.strip():
            continue  # skip empty lines
        name, item, price = [x.strip() for x in line.split(',')]
        totals[name] = totals.get(name, 0) + int(price)

# Print results
for name, total in totals.items():
    print(f"{name} -> {total}")

# Write sorted results to file
with open('totals.txt', 'w') as f:
    f.write("customer,total_spent\n")
    for name, total in sorted(totals.items(), key=lambda x: x[1], reverse=True):
        f.write(f"{name},{total}\n")
