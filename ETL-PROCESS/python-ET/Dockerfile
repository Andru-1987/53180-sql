# Use the official Python 3 image as base image
FROM python:3

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy requirements file and install dependencies
COPY ./python-ET/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r ./requirements.txt


# Copy the rest of the application code
COPY ./python-ET .

RUN rm -rf /data/sample_store_clean.csv /data/insurance_data_1000.csv

# Command to run the Python script
CMD ["python", "./main.py"]
