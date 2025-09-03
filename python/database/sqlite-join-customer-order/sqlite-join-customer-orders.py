import sqlite3
import csv

# Sample records
customers = [
    (1, "Alice", "New York"),
    (2, "Bob", "Chicago"),
    (3, "Charlie", "San Francisco")
]

# 1. Connect to SQLite database (creates customers.db if not exists)
conn = sqlite3.connect("customers.db")
cursor = conn.cursor()

# 2. Create customers table with a primary key
cursor.execute("""
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT,
    City TEXT
)
""")

# 3. Insert records
cursor.executemany("INSERT OR IGNORE INTO customers VALUES (?, ?, ?)", customers)
conn.commit()



# Sample records
orders = [
    ("A001", 1, 120),
    ("A002", 2, 200),
    ("A003", 1, 80),
    ("A004", 3, 150)
]

# 1. Connect to SQLite database (creates orders.db if not exists)
conn = sqlite3.connect("orders.db")
cursor = conn.cursor()

# 2. Create orders table with a primary key
cursor.execute("""
CREATE TABLE IF NOT EXISTS orders (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT,
    City TEXT
)
""")

# 3. Insert records
cursor.executemany("INSERT OR IGNORE INTO orders VALUES (?, ?, ?)", orders)
conn.commit()