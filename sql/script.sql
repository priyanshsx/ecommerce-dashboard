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
    -- this will give us the english product categories and the geographic regions that drive  
    -- the most revenues using the order_items 
    -- dividing into two groups: 
    -- Group A: orders linked to order_items, and orders linked to customers 
    -- Group B: products linked to product_category_name_translation 
    -- Group B can be joined using a left join where we join products with product_category_name_translation 
    -- Group A i'm not sure how but I know that groups A and B can be joined using product_id 
    -- i think a left join is preferred 

CREATE TABLE question_one AS 
SELECT 
    product_category_name_translation.product_category_name_english, 
    customers.customer_city,
    SUM(order_items.price) AS total_revenue
FROM order_items 
LEFT JOIN orders
    ON order_items.order_id = orders.order_id 
LEFT JOIN customers 
    ON orders.customer_id = customers.customer_id 
LEFT JOIN products 
    ON order_items.product_id = products.product_id 
LEFT JOIN product_category_name_translation
    ON products.product_category_name = product_category_name_translation.product_category_name 
GROUP BY 
    product_category_name_english,
    customer_city
ORDER BY 
    total_revenue DESC

-- 2. how much revenue comes from repeat customers 
    -- tables needed: customers (for unique customer ids) + orders + order_payments 
    -- we can use a CTE for computing the total orders per customer_unique_id 
    -- if the count > 1, that customer is a repeat customer 
    -- 
CREATE TABLE question_two AS  
WITH customer_classification AS (
    SELECT 
        customer_unique_id,
        COUNT(customer_id) AS total_orders,
        CASE 
            WHEN COUNT(customer_id) > 1 THEN 'repeat customer'
            ELSE 'one-time customer' 
            END AS customer_type 
    FROM customers 
    GROUP BY customer_unique_id
    )
SELECT 
    customer_classification.customer_type,
    SUM(order_items.price) AS total_revenue 
FROM customer_classification 
LEFT JOIN customers 
    ON customer_classification.customer_unique_id = customers.customer_unique_id
LEFT JOIN orders 
    ON customers.customer_id = orders.customer_id
LEFT JOIN order_items 
    ON orders.order_id = order_items.order_id 
GROUP BY customer_type
ORDER BY total_revenue DESC 

-- 3. which customer segments have the highest order value 
    -- for this we will be classifying customers into geographic segments, 
    -- purchasing power (one-time buyer vs. repeat buyers),
    -- payment behavior (installment users vs. pay-in-full users), and 
    -- order timing (holiday shoppers vs off-season shoppers)
    
    -- tables needed: customers + orders + order_payments 
    -- we can look at the geographical regions from the customers table, 
    -- asociate the customer_unique_id to one-time vs. repeat buyers, 
    -- use the order_payments to analyze installment users vs. pay-in-full users,
    -- 
CREATE TABLE question_three AS  
WITH customer_loyalty AS (
    SELECT 
        customer_unique_id,
        COUNT(customer_id) AS total_orders,
        CASE 
            WHEN COUNT(customer_id) > 1 THEN 'repeat customer'
            ELSE 'one-time customer' 
            END AS loyalty_segment 
    FROM customers 
    GROUP BY customer_unique_id
    )
SELECT 
    customers.customer_state AS geographic_segment,
    customer_loyalty.loyalty_segment,

    CASE 
        WHEN payment_installments = 1 THEN 'pay-in-full'
        ELSE 'installments'
    END AS payment_segment,

    ROUND(AVG(order_payments.payment_value), 2) AS avg_order_value,
    COUNT(DISTINCT orders.order_id) AS total_orders 

FROM orders 
LEFT JOIN customers 
    ON orders.customer_id = customers.customer_id 
LEFT JOIN customer_loyalty 
    ON customers.customer_unique_id = customer_loyalty.customer_unique_id 
LEFT JOIN order_payments 
    ON orders.order_id = order_payments.order_id 

GROUP BY 
    customers.customer_state,
    customer_loyalty.loyalty_segment,
    payment_segment 
ORDER BY 
    avg_order_value DESC 

-- 4. revenue from repeat customers 
    -- "late" is defined by comparing order_delivered_customer_date to order_estimated_delivery_date
    -- in the orders table
    -- tables needed: orders + order_reviews 
    -- here we will join orders and order_reviews table ON order_id 
    -- if there's even a single day's delay when we compare order_estimated_delivery date
    -- and order_delivered_customer_date, that will be considered late 
    -- we will then check for the same order_id in the order_reviews table what 
    -- review_score they left
    -- to get a baseline of scores, we can check the average of the scores for timely delivered 
    -- deliveries so we we have a benchmark 

CREATE TABLE question_four AS 
SELECT 
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'late'
        ELSE 'on time'
    END AS delivery_status,
    AVG(review_score) AS avg_review_score,
    COUNT(orders.order_id) AS total_orders 
FROM orders 
LEFT JOIN order_reviews 
ON orders.order_id = order_reviews.order_id 
GROUP BY delivery_status 

-- 5. categories or regions experience disproportionately high freight costs or delivery delays
    -- tables needed: order_items + products + orders + customers + product_category_name_translation
    -- i think this would be similar to the previous question just this time we're looking at 
    -- high freight costs and delivery delays 
    -- for delivery delays: we can look at the comparison between delivered_customer_date and 
    -- order_estimated_delivery_date 
    -- we can also average out the freigh costs as a baseline to compare which regions have the highest
    -- freight costs 

CREATE TABLE question_five AS 
SELECT 
    product_category_name_translation.product_category_name_english,
    customers.customer_state,
    ROUND(AVG(order_items.freight_value), 2) AS avg_freight_cost,

    SUM(CASE 
        WHEN orders.order_delivered_customer_date > orders.order_estimated_delivery_date THEN 1
        ELSE 0
        END) AS total_late_deliveries
FROM order_items 
LEFT JOIN orders 
    ON order_items.order_id = orders.order_id 
LEFT JOIN customers     
    ON orders.customer_id = customers.customer_id 
LEFT JOIN products 
    ON order_items.product_id = products.product_id 
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name 
GROUP BY  
    product_category_name_translation.product_category_name_english,
    customers.customer_state 
ORDER BY total_late_deliveries DESC
