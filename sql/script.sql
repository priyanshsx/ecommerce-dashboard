-- created all tables 

CREATE TABLE table_name AS SELECT * FROM read_csv_auto('csv_file_name.csv')

-- sanity check 

SELECT * FROM table_name 

-- checking for NULLs 

SELECT * FROM table_name WHERE col1 IS NULL OR col2 IS NULL...

-- understanding the schema: 
-- order_id is common between: 
-- order_payments_dataset, orders_dataset, order_reviews_dataset, and order_items_dataset

-- zip_code_prefix is common between: 
-- customers_dataset and geolocation_dataset
-- how are customer_zip_code_prefix and geolocation_zip_code_prefix different to each other? 

-- orders_dataset and customers_dataset can be combined ON 
-- customer_id 

-- order_items_dataset and products_dataset can be combined on 
-- seller_id
 