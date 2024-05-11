import pandas as pd
import os

sample_store_path = os.getenv("FILE")
sample_store_output= os.getenv("FILE_OUTPUT")
insurence_url = os.getenv("CSV_PATH")
insurence_output= os.getenv("CSV_FILE")

def main():

    insurence=pd.read_csv(insurence_url,sep=",")    

    data = pd.read_csv(sample_store_path,sep=",",date_format="%m-%d-%Y")
    data['Order Date'] = pd.to_datetime(data['Order Date'], format='%m/%d/%Y').dt.strftime('%Y-%m-%d')
    data['Ship Date'] = pd.to_datetime(data['Ship Date'], format='%m/%d/%Y').dt.strftime('%Y-%m-%d')
    data=data.drop("row_id",axis=1)
    try:
        insurence.to_csv(insurence_output,index=False)
        data.to_csv(sample_store_output,index=False)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main()