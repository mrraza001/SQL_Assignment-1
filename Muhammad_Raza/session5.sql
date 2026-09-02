-- SECTION 5: SUBQUERIES

use bikestores;

-- TASK 29: Find all products whose list price is above the overall average list price

SELECT product_name, list_price
FROM production.products
WHERE list_price > (SELECT AVG(list_price) FROM production.products);

-- TASK 30: Find customers who have never placed an order

SELECT first_name, last_name, city
FROM sales.customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM sales.orders);

-- TASK 31: List the most expensive product in each category

WITH ranked_products AS (
    SELECT p.product_name,
           c.category_name,
           p.list_price,
           ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY p.list_price DESC) as rank
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
)
SELECT category_name, product_name, list_price
FROM ranked_products
WHERE rank = 1;

-- TASK 32: Find staff members who work in the store that generated the most revenue

WITH store_revenue AS (
    SELECT st.store_id,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.stores st
    JOIN sales.orders o ON st.store_id = o.store_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY st.store_id
)
SELECT s.first_name + ' ' + s.last_name AS staff_name,
       st.store_name
FROM sales.staffs s
JOIN sales.stores st ON s.store_id = st.store_id
WHERE st.store_id = (SELECT TOP 1 store_id FROM store_revenue ORDER BY total_revenue DESC);

-- TASK 33: Find orders where the total order value exceeds 5000

SELECT order_id,
       SUM(quantity * list_price * (1 - discount)) AS order_total
FROM sales.order_items
GROUP BY order_id
HAVING SUM(quantity * list_price * (1 - discount)) > 5000;

-- TASK 34: List products that have never been ordered by any customer

SELECT p.product_id, p.product_name
FROM production.products p
WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM sales.order_items);

-- TASK 35: Find the customer who has spent the most money overall

SELECT TOP 1 c.first_name + ' ' + c.last_name AS customer_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

--END


