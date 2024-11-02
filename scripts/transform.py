import pandas as pd
import os 

def load_data(file_path):
    """Load data from CSV file."""
    try:
        df=pd.read_csv(file_path)
        print(f'Data loaded successfully from {file_path}')
        return df
    except Exception as e:
        print(f'Error loading data: {e}')
        return None

def clean_data(df):
    """Clean dataframe by removing duplicates and handling missing values. """
    print('Initial DataFrame info.')
    print(df.info())

    # Check for and drop duplicate values.
    duplicates=df.duplicated().sum()
    print(f'Number of duplicate rows: {duplicates}')
    df.drop_duplicates(inplace=True)

    # Check for and drop null values
    null_values=df.isnull().sum()
    print(f"Null values in each column:\n{null_values}")
    df.dropna(inplace=True)

    return df

def transform_data(df):
    """Transform the DataFrame by changing datatype and Feature engineering."""

    # Changing data types
    df['unit_price'] = df['unit_price'].str.replace('$', '').astype(float)
    df['quantity'] = df['quantity'].astype(int)

    # Feature engineering: adding a new column total_price
    df['total_price'] = df['quantity'] * df['unit_price']
    print("Data transformation completed successfully.")
    
    return df

def save_data(df,output_path):
    """Save the clean and transformed DataFrame to a CSV file. """
    try:
        df.to_csv(output_path,index=False)
        print(f'Data saved successfully to {output_path}.')
    except Exception as e:
        print(f'Error saving data: {e}')


if __name__ == "__main__":

    input_file_path = 'data/external/Walmart.csv'
    output_file_path = 'data/processed/cleaned_walmart_data.csv'

    df=load_data(input_file_path)

    if df is not None:
        df = clean_data(df)
        df = transform_data(df)
        print("Transformed DataFrame:")
        print(df.head())  # Display the first few rows of the transformed DataFrame
        
        save_data(df, output_file_path)


