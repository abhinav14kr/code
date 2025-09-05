# sqlite-customer-category-spending.py
import sqlite3

# Sample data (aligned with the prompt)
customers = [
    (1, "Alice", "New York"),
    (2, "Bob", "Chicago"),
    (3, "Charlie", "San Francisco"),
]

orders = [
    ("A001", 1, "P01", 120),
    ("A002", 2, "P02", 200),
    ("A003", 1, "P03", 80),
    ("A004", 3, "P01", 150),
]

products = [
    ("P01", "Laptop", "Electronics"),
    ("P02", "Shirt", "Clothing"),
    ("P03", "Headphones", "Electronics"),
]

# Connect to main db (shop.db)
conn = sqlite3.connect("shop.db")
c = conn.cursor()

# Create base tables
c.execute("""
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    City TEXT
)
""")

c.execute("""
CREATE TABLE IF NOT EXISTS products (
    ProductID TEXT PRIMARY KEY,
    ProductName TEXT NOT NULL,
    Category TEXT NOT NULL
)
""")

c.execute("""
CREATE TABLE IF NOT EXISTS orders (
    OrderID TEXT PRIMARY KEY,
    CustomerID INTEGER NOT NULL,
    ProductID TEXT NOT NULL,
    Amount INTEGER NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
)
""")

# Clear existing data to avoid UNIQUE constraint errors
c.execute("DELETE FROM customers")
c.execute("DELETE FROM products")
c.execute("DELETE FROM orders")

# Insert data
c.executemany("INSERT INTO customers VALUES (?, ?, ?)", customers)
c.executemany("INSERT INTO products VALUES (?, ?, ?)", products)
c.executemany("INSERT INTO orders VALUES (?, ?, ?, ?)", orders)


# Attach a new database to store results
c.execute("ATTACH DATABASE 'TopSpendersByCity.db' AS results_db")



# Drop old results table if it exists
c.execute("DROP TABLE IF EXISTS results_db.TopSpendersByCity")

# Create results table in results.db with aggregated data
c.execute("""
CREATE TABLE results_db.TopSpendersByCity AS
WITH spend AS (
  SELECT
    c.City,
    c.CustomerID,
    c.Name AS Customer,
    SUM(o.Amount) AS Total_Spending
  FROM customers c
  JOIN orders o ON o.CustomerID = c.CustomerID
  GROUP BY c.City, c.CustomerID, c.Name
),
ranked AS (
  SELECT
    City, Customer, Total_Spending,
    ROW_NUMBER() OVER (PARTITION BY City ORDER BY Total_Spending DESC) AS rn
  FROM spend
)
SELECT City, Customer, Total_Spending
FROM ranked
WHERE rn = 1
ORDER BY City
""")

# Preview results
print("== Results stored in results.db ==")
for row in c.execute("SELECT * FROM results_db.TopSpendersByCity"):
    print(row)

conn.commit()
conn.close()
