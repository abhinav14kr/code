import pandas as pd
import sqlite3
import os
import glob

def merge_sales_etl(folder_path):
    csv_files = glob.glob(os.path.join(folder_path, "*.csv"))
    dataframes_list = []

    for file in csv_files:
        try:
            df = pd.read_csv(file)
            dataframes_list.append(df)
        except FileNotFoundError:
            print(f"File {file} not found.")
        except pd.errors.EmptyDataError:
            print(f"File {file} is empty.")
        except Exception as e:
            print(f"Error reading {file}: {e}")

    if not dataframes_list:
        print("No data to process.")
        return

    # Concatenate
    merged_df = pd.concat(dataframes_list, ignore_index=True)

    # Deduplicate
    merged_df = merged_df.drop_duplicates(subset="OrderID")

    # Normalize Date
    merged_df["Date"] = pd.to_datetime(merged_df["Date"], errors="coerce").dt.strftime("%Y-%m-%d")

    # Save cleaned CSV
    merged_df.to_csv("all_sales_clean.csv", index=False)

    # Write to SQLite DB
    with sqlite3.connect("merged_sales.db") as conn:
        merged_df.to_sql("Sales", conn, if_exists="replace", index=False)

        # Confirm write by reading it back
        result = pd.read_sql_query("SELECT * FROM Sales", conn)
        print("\n Data written to 'merged_sales.db' in table 'Sales':")
        print(result)
        
        # Bonus: Total Sales summary grouped by month
        monthly_sales = pd.read_sql_query("""
            SELECT 
                strftime('%Y-%m', Date) as Month,
                SUM(Amount) as Total_Sales,
                COUNT(*) as Order_Count
            FROM Sales 
            GROUP BY strftime('%Y-%m', Date)
            ORDER BY Month
        """, conn)
        
        print("\n Total Sales Summary by Month:")
        print(monthly_sales)

# Execute the ETL pipeline
if __name__ == "__main__":
    # Run ETL for current directory (where CSV files are located)
    current_folder = "."
    print("🚀 Starting ETL Pipeline...")
    merge_sales_etl(current_folder)

