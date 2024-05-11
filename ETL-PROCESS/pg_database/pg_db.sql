\c database_stage ;

CREATE TABLE orders (
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(255),
    customer_id VARCHAR(255),
    customer_name VARCHAR(255),
    segment VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postal_code VARCHAR(255),
    region VARCHAR(255),
    product_id VARCHAR(255),
    category VARCHAR(255),
    sub_category VARCHAR(255),
    product_name VARCHAR(255),
    sales NUMERIC,
    quantity INTEGER,
    discount NUMERIC,
    profit NUMERIC
);

COPY orders(order_id,order_date, ship_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit) 
FROM '/data/sample_store_clean.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE insurance_user (
    user_id SERIAL PRIMARY KEY,
    case_id INTEGER,
    income NUMERIC,
    age INTEGER,
    sex CHAR(1),
    approval VARCHAR(20),
    fraud VARCHAR(20),
    claims NUMERIC
);


COPY insurance_user (case_id, income, age, sex, approval, fraud, claims)
FROM '/data/insurance_data_1000.csv' DELIMITER ',' CSV HEADER;




