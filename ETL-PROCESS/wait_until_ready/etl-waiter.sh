#!/bin/sh

# Wait until MySQL is ready
until mysqladmin ping -h mysql-container --silent
do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

# Wait until PostgreSQL is ready
until pg_isready -h pg-container -p 5432 -U andru &>/dev/null
do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "PostgreSQL is ready."


echo "MySQL is ready."

# Connect to PostgreSQL and export data to MySQL
echo "Exporting data from PostgreSQL to MySQL Starts..."
# Command to run the application

python3 /main.py

rm -rf /data/insurance_data_1000.csv /data/sample_store_clean.csv

echo "Finish"