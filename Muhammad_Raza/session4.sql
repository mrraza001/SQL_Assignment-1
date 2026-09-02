-- SECTION 4: GROUP BY & AGGREGATES

use bikestores;

-- TASK 20: Count how many products exist in each category

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- TASK 21: Find the average list price of products per brand

SELECT b.brand_name, AVG(p.list_price) AS avg_price
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name;

-- TASK 22: For each store, count the total number of orders

SELECT st.store_name, COUNT(o.order_id) AS order_count
FROM sales.orders o
JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY st.store_name;

-- TASK 23: Find the total revenue per order

SELECT order_id,
       SUM(quantity * list_price * (1 - discount)) AS total_revenue
FROM sales.order_items
GROUP BY order_id;

-- TASK 24: Find each customer's total number of orders. Sort by order count descending.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC;

-- TASK 25: Find the brand that has the highest average product price

SELECT TOP 1 b.brand_name, AVG(p.list_price) AS avg_price
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY avg_price DESC;

-- TASK 26: List categories that have more than 50 products

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 50;

-- TASK 27: For each store, find the total revenue generated across all orders

SELECT st.store_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.stores st ON o.store_id = st.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.store_name;

-- TASK 28: Find how many orders each staff member handled, and show only those who handled more than 50 orders
SELECT s.first_name + ' ' + s.last_name AS staff_name,
       COUNT(o.order_id) AS order_count
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(o.order_id) > 50;

--end
