import sqlite3

# Sample data
customers = [
    (1, "Alice", "New York"),
    (2, "Bob", "Chicago"),
    (3, "Charlie", "San Francisco")
]

orders = [
    ("A001", 1, 120),
    ("A002", 2, 200),
    ("A003", 1, 80),
    ("A004", 3, 150)
]

# Connect to single database
conn = sqlite3.connect("shop.db")
cursor = conn.cursor()

# Create customers table
cursor.execute("""
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT,
    City TEXT
)
""")

# Create orders table with correct schema
cursor.execute("""
CREATE TABLE IF NOT EXISTS orders (
    OrderID TEXT PRIMARY KEY,
    CustomerID INTEGER,
    Amount INTEGER,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
)
""")

# Insert customers
cursor.executemany("INSERT OR IGNORE INTO customers VALUES (?, ?, ?)", customers)

# Insert orders
cursor.executemany("INSERT OR IGNORE INTO orders VALUES (?, ?, ?)", orders)

conn.commit()
conn.close()
