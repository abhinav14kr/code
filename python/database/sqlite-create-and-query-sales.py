import sqlite3
import csv

# Sample records
records = [
    ("A001", "Laptop", "Electronics", 1200),
    ("A002", "Mouse", "Electronics", 25),
    ("A003", "Shirt", "Clothing", 40),
    ("A004", "Tablet", "Electronics", 500),
    ("A005", "Shirt", "Clothing", 60)
]

# 1. Connect to SQLite database (creates sales.db if not exists)
conn = sqlite3.connect("sales.db")
cursor = conn.cursor()

# 2. Create Sales table with a primary key
cursor.execute("""
CREATE TABLE IF NOT EXISTS Sales (
    OrderID TEXT PRIMARY KEY,
    Product TEXT,
    Category TEXT,
    Amount REAL
)
""")

# 3. Insert records
cursor.executemany("INSERT OR IGNORE INTO Sales VALUES (?, ?, ?, ?)", records)
conn.commit()

# 4. Query: Total sales per category
cursor.execute("""
SELECT Category, SUM(Amount) AS Total_Sales
FROM Sales
GROUP BY Category
""")
category_sales = cursor.fetchall()

print("Category-wise Total Sales:")
for row in category_sales:
    print(row)

# 5. Bonus: Query top product by sales amount
cursor.execute("""
SELECT Product, SUM(Amount) AS Total_Sales
FROM Sales
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 1
""")
top_product = cursor.fetchone()
print("\nTop Product by Sales Amount:", top_product)

# 6. Bonus: Save query results into a CSV file
with open("category_sales.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Category", "Total_Sales"])
    writer.writerows(category_sales)

print("\nResults saved to category_sales.csv")

# Close connection
conn.close()
