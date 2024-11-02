import kaggle
import os

def authenticate_kaggle():
    """Authenticate to Kaggle API."""
    try:
        kaggle.api.authenticate()
        print('Kaggle authentication successful.')
    except Exception as e:
        print(f"Error during Kaggle authentication: {e}") 

def download_dataset(dataset_name,download_path):
    """Download dataset from kaggle and unzip it."""
    try:    
        if not os.path.exists(download_path):
            os.mkdir(download_path)       # Create directory if it doesn't exist

        kaggle.api.dataset_download_files(dataset_name,path=download_path, unzip=True)
        print(f'Dataset {dataset_name} downloaded and unziped to {download_path}.' )
    except Exception as e:
        print(f'Error downloading dataset {dataset_name}:{e}')

if __name__=='__main__':

    DATASET_NAME='najir0123/walmart-10k-sales-datasets'
    DOWNLOAD_PATH='data/external/'

    authenticate_kaggle()
    download_dataset(DATASET_NAME,DOWNLOAD_PATH)