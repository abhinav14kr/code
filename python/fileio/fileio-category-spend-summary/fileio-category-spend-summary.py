import csv

# Open the CSV file
with open('sales.csv', 'r') as f:
    line = csv.reader(f)
    next(line)

    groups = {}

    # Iterate over each row in the CSV
    for row in line:
        if len(row) < 4:
            continue  
        
        name, item, category, price = row

        try:
            price = float(price)
        except ValueError:
            continue  

  
        if category not in groups:
            groups[category] = 0
        groups[category] += price


for category, total in groups.items():
    print(f"{category} -> {total}")



with open('category_totals.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['category', 'total_spent'])  

    for category, total in groups.items():
        writer.writerow([category.capitalize(), total])
