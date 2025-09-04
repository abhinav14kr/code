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

# Clean slate (so reruns are safe)
c.executescript("""
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
""")

# Create base tables
c.execute("""
CREATE TABLE customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    City TEXT
)
""")

c.execute("""
CREATE TABLE products (
    ProductID TEXT PRIMARY KEY,
    ProductName TEXT NOT NULL,
    Category TEXT NOT NULL
)
""")

c.execute("""
CREATE TABLE orders (
    OrderID TEXT PRIMARY KEY,
    CustomerID INTEGER NOT NULL,
    ProductID TEXT NOT NULL,
    Amount INTEGER NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
)
""")

# Insert data
c.executemany("INSERT INTO customers VALUES (?, ?, ?)", customers)
c.executemany("INSERT INTO products VALUES (?, ?, ?)", products)
c.executemany("INSERT INTO orders VALUES (?, ?, ?, ?)", orders)

# Attach a new database to store results
c.execute("ATTACH DATABASE 'results.db' AS results_db")

# Drop old results table if it exists
c.execute("DROP TABLE IF EXISTS results_db.CustomerCategorySpend")

# Create results table in results.db with aggregated data
c.execute("""
CREATE TABLE results_db.CustomerCategorySpend AS
SELECT
  C.Name AS Customer,
  P.Category AS Category,
  SUM(O.Amount) AS Total_Spending
FROM orders O
JOIN customers C ON O.CustomerID = C.CustomerID
JOIN products  P ON O.ProductID  = P.ProductID
GROUP BY C.Name, P.Category
ORDER BY C.Name, P.Category
""")

# Preview results
print("== Results stored in results.db ==")
for row in c.execute("SELECT * FROM results_db.CustomerCategorySpend"):
    print(row)

conn.commit()
conn.close()
