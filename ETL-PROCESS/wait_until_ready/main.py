import logging
import psycopg2
import mysql.connector
import sys

# Configure logging
logging.basicConfig(filename='/export.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

pg_host = "pg-container"
mysql_host = "mysql-container"

# Connect to PostgreSQL
try:
    logging.info("Connecting to PostgreSQL...")
    pg_conn = psycopg2.connect(
        host=pg_host,
        database="database_stage",
        user="andru",
        password="1234"
    )
    pg_cursor = pg_conn.cursor()
    logging.info("Connected to PostgreSQL!")

except psycopg2.Error as e:
    logging.error("Failed to connect to PostgreSQL!")
    logging.error(e)
    sys.exit(1)

# Connect to MySQL
try:
    logging.info("Connecting to MySQL...")
    mysql_conn = mysql.connector.connect(
        host=mysql_host,
        user="root",
        password="coderhouse",
        database="database_stage"
    )
    mysql_cursor = mysql_conn.cursor()
    logging.info("Connected to MySQL!")

except mysql.connector.Error as e:
    logging.error("Failed to connect to MySQL!")
    logging.error(e)
    pg_cursor.close()
    pg_conn.close()
    sys.exit(1)

# Export data from PostgreSQL to MySQL
try:
    logging.info("Exporting data from PostgreSQL to MySQL...")
    pg_cursor.execute("SELECT * FROM orders;")
    orders_rows = pg_cursor.fetchall()

    pg_cursor.execute("SELECT * FROM insurance_user;")
    insurance_user_rows = pg_cursor.fetchall()

    if len(list(orders_rows)) == 0:
        logging.info("Amount orders is 0")

    if len(list(insurance_user_rows)) == 0:
        logging.info("Amount users is 0")
        
    # Orders table
    for row in orders_rows:
        try:
            mysql_cursor.execute("INSERT INTO orders VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", row)
        except mysql.connector.Error as error:
            logging.error("Error inserting data into orders table: %s", error)

    # Insurance user table
    for row in insurance_user_rows:
        try:
            mysql_cursor.execute("INSERT INTO insurance_user VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", row)
        except mysql.connector.Error as error:
            logging.error("Error inserting data into insurance_user table: %s", error)

    mysql_conn.commit()
    logging.info("Data export from PostgreSQL to MySQL completed successfully!")

except psycopg2.Error as e:
    logging.error("Error fetching data from PostgreSQL!")
    logging.error(e)

except mysql.connector.Error as e:
    logging.error("Error inserting data into MySQL!")
    logging.error(e)

finally:
    # Close the connections
    pg_cursor.close()
    pg_conn.close()
    mysql_cursor.close()
    mysql_conn.close()
