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

-- checking for duplicate order_ids in orders: 
SELECT COUNT(*) AS total_rows, 
COUNT(DISTINCT order_id) AS unique_orders,
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT order_id) THEN 'unique'
        ELSE 'duplicates'
    END AS status 
FROM orders 

-- this yielded that the order_ids in the orders table are unique 

-- checking for repeated order_ids in order_items 
-- this is because customers can purchase multiple items in a single order 
-- we need to check which order_ids are duplicates and repeated how many times 

SELECT order_id, COUNT(*) AS item_count
FROM order_items 
GROUP BY order_id 
HAVING COUNT(*) > 1
ORDER BY item_count DESC


-- now checking the order_payments table 
SELECT * FROM order_payments 
-- one analysis that can be carried out on this table is to understand: 
-- which payment methods are used more often 
-- which products require a greater number of instalment periods 
-- payment method distribution broken down by customer state/region or customer segment (maybe even product)
-- look at customers using payment_type = 'voucher' to see if repeat payments are through organic payments or through promotions 
-- checking what segments have split payments
-- payment_value vs payment_installments to see the point after which $ amount 

-- checking for count of different payment methods 
SELECT payment_type, COUNT (*) AS payment_count, 
FROM order_payments 
GROUP BY payment_type 
ORDER BY payment_count DESC

-- checking the order_ids that have the maximum number of installments 
SELECT order_id,MAX(payment_installments) AS total_installments
FROM order_payments
GROUP BY order_id 
ORDER BY total_installments DESC

-- the geolocation table can be joined with product_category_name_translation, order_items to analyze
-- the product categories and geographic regions that generate the most revenue 

SELECT * FROM geolocation 

-- the product_category_name_translation is super essential to understand products in English 

SELECT * FROM product_category_name_translation 

-- the orders table is useful for determining when the orders get approved and delivered to the customer 
-- after the purchase timestamp 

SELECT * from orders 

-- answering research questions using custom tables 

-- 1. which product categories and geographic regions generate the most revenues 
-- tables needed: order_items + orders + customers + product_category_name_translation + products 
-- this will give us the english product categories and the geographic regions that drive the most revenues 
-- using the order_items 



-- 2. how much revenue comes from repeat customers 
-- tables needed: customers (for unique customer ids) + orders + order_payments 

-- 3. which customer segments have the highest order value 
-- for this we will be classifying customers into geographic segments, purchasing power (one-time buyer vs. repeat buyers),
-- payment behavior (installment users vs. pay-in-full users), and order timing (holiday shoppers vs off-season shoppers)

-- 4. revenue from repeat customers 
-- here, we will define "late" by comparing order_delivered_customer_date to order_estimated_delivery_date
-- in the orders table
-- tables needed: orders + order_reviews 

-- 5. categories or regions experience disproportionately high freight costs or delivery delays
-- tables needed: order_items + products + orders + customers 