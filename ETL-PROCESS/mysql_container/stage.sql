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
    sales DECIMAL(20,4),
    quantity INT,
    discount DECIMAL(20,4),
    profit DECIMAL(20,4)
);


CREATE TABLE insurance_user (
    user_id SERIAL PRIMARY KEY,
    case_id INT,
    income DECIMAL(20,4),
    age INT,
    sex CHAR(1),
    approval VARCHAR(20),
    fraud VARCHAR(20),
    claims DECIMAL(20,4)
);