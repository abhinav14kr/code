import pandas as pd, sqlite3

df = pd.read_csv("transactions.csv")
print(df.head())

clean_df = df.dropna(subset=["Customer"])
print(clean_df.head())

clean_df["Amount"] = pd.to_numeric(clean_df["Amount"], errors="coerce")
normalized_dates = pd.to_datetime(clean_df["Date"], errors="coerce", dayfirst=True).dt.strftime("%Y-%m-%d")
clean_df["Date"] = normalized_dates
print(clean_df.head())  


with sqlite3.connect("etl.db") as conn:
    clean_df.to_sql("Transactions", conn, if_exists="replace", index=False)