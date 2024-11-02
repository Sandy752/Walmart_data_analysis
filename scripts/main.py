from extract import download_dataset  # Importing the download function from extract.py
from transform import load_data, clean_data, transform_data, save_data  # Importing necessary functions from transform.py
from load import load_data_to_sql  # Importing the load function from load.py
import os

def main():
    # Step 1: Extract Data
    dataset_name = 'najir0123/walmart-10k-sales-datasets'
    download_path = 'data/external/'
    
    if not os.path.exists(download_path):
        os.makedirs(download_path)  # Create directory if it doesn't exist

    download_dataset(dataset_name, download_path)  # Call the download function

    # Step 2: Transform Data
    input_file_path = os.path.join(download_path, 'Walmart.csv')  # Adjust the file name as necessary
    output_file_path = 'data/processed/cleaned_walmart_data.csv'
    
    df = load_data(input_file_path)  # Load the data
    if df is not None:
        df = clean_data(df)  # Clean the data
        df = transform_data(df)  # Transform the data
        save_data(df, output_file_path)  # Save the cleaned data

    # Step 3: Load Data into SQL
    table_name = 'walmart'
    connection_string = 'mysql+pymysql://testuser:sandy@localhost:3306/walmart'
    
    load_data_to_sql(output_file_path, table_name, connection_string)  # Load data into SQL

if __name__ == "__main__":
    main()
