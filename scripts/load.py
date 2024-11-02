
import pandas as pd
import sqlalchemy as sql
import pymysql

def load_data_to_sql(file_path,table_name,connection_string):
    '''Load data from a CSV  file to SQL database table'''
    try:
        # Create SQL Alchemy engine
        engine=sql.create_engine(connection_string)
        conn=engine.connect()
        print('Connection established successfully')

        df=pd.read_csv(file_path)
        df.to_sql(name=table_name,con=conn,if_exists='append',index=False)
        print(f'Data inserted into {table_name} successfully.')

    except Exception as e:
        print(f'Error during loading data to SQL: {e}') 

    finally:
        conn.close()
        print("Database connection closed.")
       

if __name__=='__main__':

    FILE_PATH = 'data/processed/cleaned_walmart_data.csv'
    TABLE_NAME ='walmart'
    CONNECTION_STRING = 'mysql+pymysql://testuser:sandy@localhost:3306/walmart' 

    load_data_to_sql(FILE_PATH,TABLE_NAME,CONNECTION_STRING)