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

# Connecting to single database
conn = sqlite3.connect("shop.db")
cursor = conn.cursor()

#  customers table
cursor.execute("""
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT,
    City TEXT
)
""")

# Creating orders table with correct schema
cursor.execute("""
CREATE TABLE IF NOT EXISTS orders (
    OrderID TEXT PRIMARY KEY,
    CustomerID INTEGER,
    Amount INTEGER,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
)
""")

# Inserting customers values
cursor.executemany("INSERT OR IGNORE INTO customers VALUES (?, ?, ?)", customers)

# Inserting orders values
cursor.executemany("INSERT OR IGNORE INTO orders VALUES (?, ?, ?)", orders)



cursor.execute("""
SELECT SUM(O.Amount) as total_amount, C.Name as customer_name, C.City as customer_city
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
GROUP BY 2, 3
""")
category_sales = cursor.fetchall()

for row in category_sales:
    print(row)


import csv
with open('customer_spending.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Customer', 'City', 'Total_Spending'])
    writer.writerows(category_sales)

conn.close()     # make sure to close this only after all the querying and writing is done as doing it before will not help you perform queries against db