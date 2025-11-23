import pandas as pd
from dagster import asset

@asset
def raw_data():
    import pandas as pd
    df = pd.read_csv("data.csv", on_bad_lines="skip")
    return df

@asset
def cleaned_data(raw_data):
    df = raw_data.dropna()
    return df

@asset
def stored_data(cleaned_data):
    cleaned_data.to_csv("cleaned_output.csv", index=False)
    return "cleaned_output.csv"

@asset
def validate(stored_data):
    df = pd.read_csv(stored_data)
    row_count = len(df)
    print("Row count:", row_count)
    return row_count
