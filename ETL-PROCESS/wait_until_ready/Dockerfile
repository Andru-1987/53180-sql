FROM python:3


RUN apt-get update && apt-get install -y \
    postgresql-client \
    default-mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY ./wait_until_ready/requirements.txt /requirements.txt 
COPY ./wait_until_ready/main.py /main.py

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /requirements.txt
