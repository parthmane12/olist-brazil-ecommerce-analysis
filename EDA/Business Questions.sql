-- ============================================================
-- Olist Funnel Analysis — SQL EDA & Business Questions
-- Tables: orders, items, payments, reviews, customers, products, sellers
-- ============================================================


-- ============================================================
-- A. Filtering — WHERE, CASE, date functions
-- ============================================================

-- Q1: How many orders were placed in each order_status category (e.g. delivered, canceled, shipped)?

SELECT order_status, COUNT(*) AS Count
FROM orders
GROUP BY order_status;


-- Q2: How many orders were canceled, and what percentage of total orders does that represent?

SELECT COUNT(*) AS total_orders,(
SELECT COUNT(*)
FROM orders
WHERE order_status = 'canceled') AS canceled_orders, 
100*ROUND(((
SELECT COUNT(*)
FROM orders
WHERE order_status = 'canceled')/COUNT(*)),4) AS percentage_cancel
FROM orders;


-- Q3: How many orders were placed in the last 6 months of available data?

SELECT COUNT(*) AS orders_last_6_months
FROM orders
WHERE order_purchase_timestamp >= DATE_SUB(
    (SELECT MAX(order_purchase_timestamp) FROM orders),
    INTERVAL 6 MONTH
);


-- Q4: How many orders had a total payment value greater than R$500?

SELECT COUNT(*) as total_orders_grater_than_500$
FROM payments
WHERE total_payment_value > 500;


-- Q5: Using CASE WHEN, bucket orders into "Same-day," "1-3 days," "4-7 days," and "8+ days"
--     based on time from purchase to delivery -- then count orders in each bucket.

SELECT
    CASE
        WHEN order_delivered_customer_date IS NULL THEN 'Not Delivered'
        WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) = 0 THEN 'Same-day'
        WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) BETWEEN 1 AND 3 THEN '1-3 days'
        WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) BETWEEN 4 AND 7 THEN '4-7 days'
        ELSE '8+ days'
    END AS delivery_bucket,
    COUNT(*) AS order_count
FROM orders
GROUP BY delivery_bucket
ORDER BY order_count DESC;


-- ============================================================
-- B. Aggregation & GROUP BY
-- ============================================================

-- Q6: What is the total revenue (sum of item_revenue) by product category?

SELECT product_category_name_english AS product_category, ROUND(SUM(item_revenue)) AS total_revenue
FROM products as p
JOIN items as i 
	ON p.product_id = i.product_id
GROUP BY product_category_name_english
ORDER BY 2 DESC;


-- Q7: What is the average freight value by customer state?

SELECT customer_state, ROUND(AVG(freight_value),2) AS average_freight_value
FROM items AS i
JOIN orders AS o 
	ON o.order_id = i.order_id
JOIN customers AS c
	ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY 2 DESC;


-- Q8: What is the average review score by product category?

SELECT product_category_name_english AS product_category , ROUND(AVG(review_score),3) AS avg_review
FROM reviews AS r
JOIN items AS i
	ON i.order_id = r.order_id
JOIN products AS p
	ON p.product_id = i.product_id
GROUP BY product_category_name_english
ORDER BY 2 DESC;


-- Q9: What is the monthly order volume trend (orders per calendar month)?

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS ordered_month, SUM(n_items) AS volume
FROM orders AS o
JOIN items AS i
	ON o.order_id = i.order_id
GROUP BY ordered_month
ORDER BY ordered_month;


-- Q10: What is the average number of items per order, by payment type?

SELECT payment_type_primary, AVG(n_items) AS average_items_per_order
FROM items AS i
JOIN payments AS p
	ON i.order_id = p.order_id
GROUP BY payment_type_primary
ORDER BY 2 DESC;


-- Q11: What is the average time (in days) between purchase and delivery, grouped by customer state?

SELECT customer_state, AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
ORDER BY 2 DESC;


-- ============================================================
-- C. Filtering Aggregated Results — HAVING
-- ============================================================

-- Q12: Which product categories have generated more than R$100,000 in total revenue?

SELECT product_category_name_english AS product_category, SUM(item_revenue) AS total_revenue
FROM products AS p
JOIN items AS i
	ON p.product_id = i.product_id
GROUP BY product_category
HAVING total_revenue > 100000
ORDER BY total_revenue DESC;



-- Q13: Which customer states have placed fewer than 50 orders (long-tail markets worth flagging)?

SELECT customer_state, COUNT(*) AS order_count
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id
GROUP BY customer_state
HAVING order_count < 50
ORDER BY 2 DESC;


-- Q14: Which sellers have an average review score below 3.0, having sold at least 10 orders?

SELECT seller_id_first, AVG(review_score) AS avg_review, COUNT(DISTINCT i.order_id) AS orders_sold
FROM items AS i
JOIN orders AS o
	ON i.order_id = o.order_id
JOIN reviews AS r
	ON o.order_id = r.order_id
GROUP BY seller_id_first
HAVING avg_review <3 AND orders_sold >= 10
ORDER BY avg_review;


-- Q15: Which product categories have an average delivery time greater than 15 days?

SELECT product_category_name_english AS product_category, 
AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days
FROM items AS i
JOIN orders AS o
	ON i.order_id = o.order_id
JOIN products AS p
	ON i.product_id = p.product_id
GROUP BY product_category
HAVING avg_delivery_days >15
ORDER BY 2 DESC;



-- ============================================================
-- D. Joins — multi-table combinations
-- ============================================================

-- Q16: List the top 10 product categories by total revenue, joining items and products.

SELECT product_category_name_english AS product_category, ROUND(SUM(item_revenue),2) AS total_revenue
FROM items AS i
JOIN products AS p
	ON i.product_id = p.product_id
GROUP BY product_category
ORDER BY 2 DESC
LIMIT 10;


-- Q17: What is the total revenue and order count per customer state, joining orders and customers?

SELECT customer_state, ROUND(SUM(item_revenue),2) AS total_revenue, COUNT(DISTINCT o.order_id) AS order_count
FROM customers AS c 
JOIN orders AS o
	ON c.customer_id = o.customer_id
JOIN items AS i
	ON o.order_id = i.order_id
GROUP BY customer_state
ORDER BY total_revenue DESC;


-- Q18: Which sellers (joining items and sellers) generated the most revenue overall?

SELECT seller_id_first, ROUND(SUM(item_revenue),2) AS total_revenue
FROM items AS i
JOIN sellers AS s
	ON i.seller_id_first = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Q19: For each order, show the customer state, product category, and payment type in one result set
--      (join orders, customers, items, products, payments).

SELECT o.order_id, c.customer_state, p.product_category_name_english AS product_category, pm.payment_type_primary
FROM items AS i
JOIN orders AS o
	ON i.order_id = o.order_id
JOIN customers AS c
	ON o.customer_id = c.customer_id
JOIN products AS p
	ON p.product_id = i.product_id
JOIN payments AS pm
	ON pm.order_id = o.order_id;


-- Q20: Using a LEFT JOIN between orders and reviews, how many delivered orders never received a review?

SELECT COUNT(*) AS orders_delivered_with_no_review
FROM orders AS o
LEFT JOIN reviews as r
	ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND r.review_score IS NULL;


-- Q21: Using a self-join or window function, find orders placed by customers who placed more than one
--      order (repeat customers) -- join orders to itself on customer_id.

SELECT DISTINCT ord1.customer_id
FROM orders AS ord1
JOIN orders AS ord2
	ON ord1.customer_id = ord2.customer_id
    AND ord1.customer_id <> ord2.customer_id;



-- ============================================================
-- E. CTEs — building the funnel step by step
-- ============================================================

-- Q22: Write a CTE called funnel_base that computes, for every order, boolean flags for each stage
--      reached (approved, shipped, delivered, reviewed). Then query it to get total counts per stage.

WITH funnel_base AS (
    SELECT
        o.order_id,
        o.order_approved_at IS NOT NULL AS reached_approved,
        o.order_delivered_carrier_date IS NOT NULL AS reached_shipped,
        o.order_delivered_customer_date IS NOT NULL AS reached_delivered,
        r.order_id IS NOT NULL AS reached_reviewed
    FROM orders o
    LEFT JOIN reviews r
        ON o.order_id = r.order_id
)
SELECT
    COUNT(*) AS total_orders,
    SUM(reached_approved) AS approved,
    SUM(reached_shipped) AS shipped,
    SUM(reached_delivered) AS delivered,
    SUM(reached_reviewed) AS reviewed
FROM funnel_base;

-- Q23: Using a CTE, calculate the stage-to-stage conversion rate of the funnel
--      (Placed -> Approved -> Shipped -> Delivered -> Reviewed) as percentages.

WITH funnel_counts AS (
    SELECT
        COUNT(*) AS placed,
        SUM(o.order_approved_at IS NOT NULL) AS approved,
        SUM(o.order_delivered_carrier_date IS NOT NULL) AS shipped,
        SUM(o.order_delivered_customer_date IS NOT NULL) AS delivered,
        COUNT(r.order_id) AS reviewed
    FROM orders o
    LEFT JOIN reviews r
        ON o.order_id = r.order_id
)

SELECT
    placed,
    approved,
    shipped,
    delivered,
    reviewed,
    ROUND(100 * approved / placed, 2) AS pct_placed_to_approved,
    ROUND(100 * shipped / approved, 2) AS pct_approved_to_shipped,
    ROUND(100 * delivered / shipped, 2) AS pct_shipped_to_delivered,
    ROUND(100 * reviewed / delivered, 2) AS pct_delivered_to_reviewed
FROM funnel_counts;


-- Q24: Using a CTE that joins orders and payments, find the average order value for each payment type.

WITH CTE AS (
	SELECT o.order_id, pm.payment_type_primary, pm.total_payment_value
    FROM orders AS o
    JOIN payments AS pm
		ON o.order_id = pm.order_id
)
SELECT payment_type_primary, AVG(total_payment_value) AS avg_payment_value
FROM CTE
GROUP BY 1
ORDER BY 2 DESC;


-- Q25: Using a CTE to first calculate each seller's total revenue, then rank sellers using that CTE
--      -- return the top 5.

WITH sellers_revenue AS (
SELECT s.seller_id, SUM(item_revenue) AS total_revenue
FROM sellers AS s
JOIN items AS i
	ON s.seller_id = i.seller_id_first
GROUP BY seller_id
)
SELECT seller_id, total_revenue,
RANK () OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM sellers_revenue
ORDER BY total_revenue DESC
LIMIT 5;


-- Q26: Using a multi-step CTE, calculate revenue lost (in R$) at the biggest single drop-off point
--      in the funnel.


-- ============================================================
-- F. Subqueries — correlated and non-correlated
-- ============================================================

-- Q27: Find all orders where total_payment_value is greater than the overall average order value
--      (non-correlated subquery).

SELECT *
FROM payments
WHERE total_payment_value > (SELECT AVG(total_payment_value) FROM payments);


-- Q28: Find customers whose total spend is in the top 10% of all customers.
SELECT customer_id, total_spend
FROM (
    SELECT
        o.customer_id,
        SUM(pay.total_payment_value) AS total_spend,
        NTILE(10) OVER (ORDER BY SUM(pay.total_payment_value) DESC) AS spend_group
    FROM orders o
    JOIN payments pay
        ON o.order_id = pay.order_id
    GROUP BY o.customer_id
) t
WHERE spend_group = 1;

-- Q29: For each product category, find the single highest-revenue order (correlated subquery).
SELECT p.product_category_name_english, i.order_id, i.item_revenue
FROM items i
JOIN products p ON i.product_id = p.product_id
WHERE i.item_revenue = (
    SELECT MAX(i2.item_revenue)
    FROM items i2
    JOIN products p2 ON i2.product_id = p2.product_id
    WHERE p2.product_category_name_english = p.product_category_name_english
);


-- Q30: Find sellers who have never received a review below 4 stars (NOT EXISTS).
-- (requires items.seller_id — see the fix noted at the top of C_having.sql)
SELECT s.seller_id
FROM sellers s
WHERE NOT EXISTS (
    SELECT 1
    FROM items i
    JOIN reviews r ON i.order_id = r.order_id
    WHERE i.seller_id = s.seller_id AND r.review_score < 4
);


-- Q31: Find the product category with the highest average review score.
SELECT product_category_name_english, avg_score
FROM (
    SELECT p.product_category_name_english, AVG(r.review_score) AS avg_score
    FROM reviews r
    JOIN items i ON r.order_id = i.order_id
    JOIN products p ON i.product_id = p.product_id
    GROUP BY p.product_category_name_english
) category_scores
WHERE avg_score = (
    SELECT MAX(avg_score)
    FROM (
        SELECT p.product_category_name_english, AVG(r.review_score) AS avg_score
        FROM reviews r
        JOIN items i ON r.order_id = i.order_id
        JOIN products p ON i.product_id = p.product_id
        GROUP BY p.product_category_name_english
    ) all_category_scores
);


-- ============================================================
-- G. Window Functions — the core funnel/time-series toolkit
-- ============================================================

-- Q32: Using LAG(), calculate days between each customer's consecutive orders.
SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_purchase_timestamp - LAG(order_purchase_timestamp)
        OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS days_since_last_order
FROM orders;


-- Q33: Using RANK(), rank product categories by total revenue within each customer state.
WITH category_state_revenue AS (
    SELECT
        c.customer_state,
        p.product_category_name_english AS category,
        SUM(i.item_revenue) AS total_revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN items i ON o.order_id = i.order_id
    JOIN products p ON i.product_id = p.product_id
    GROUP BY c.customer_state, p.product_category_name_english
)
SELECT
    *,
    RANK() OVER (PARTITION BY customer_state ORDER BY total_revenue DESC) AS category_rank
FROM category_state_revenue
ORDER BY customer_state, category_rank;


-- Q34: Using SUM() OVER, calculate a running cumulative total of monthly revenue.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        SUM(i.item_revenue) AS revenue
    FROM orders o
    JOIN items i ON o.order_id = i.order_id
    GROUP BY order_month
)
SELECT
    order_month,
    revenue,
    SUM(revenue) OVER (ORDER BY order_month) AS cumulative_revenue
FROM monthly_revenue
ORDER BY order_month;


-- Q35: Using NTILE(4), split customers into revenue quartiles and report avg order value per quartile.
WITH customer_spend AS (
    SELECT o.customer_id, SUM(pay.total_payment_value) AS total_spend
    FROM orders o
    JOIN payments pay ON o.order_id = pay.order_id
    GROUP BY o.customer_id
),
quartiles AS (
    SELECT *, NTILE(4) OVER (ORDER BY total_spend) AS spend_quartile
    FROM customer_spend
)
SELECT
    spend_quartile,
    AVG(total_spend) AS avg_order_value,
    COUNT(*) AS num_customers
FROM quartiles
GROUP BY spend_quartile
ORDER BY spend_quartile;


-- Q36: Using ROW_NUMBER(), identify each customer's first order.
SELECT order_id, customer_id, order_purchase_timestamp
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS order_rank
    FROM orders
) ranked_orders
WHERE order_rank = 1;


-- Q37: Using AVG() OVER, compare each order's item revenue to its category's average.
SELECT
    o.order_id,
    p.product_category_name_english,
    i.item_revenue,
    AVG(i.item_revenue) OVER (PARTITION BY p.product_category_name_english) AS category_avg_revenue,
    i.item_revenue - AVG(i.item_revenue) OVER (PARTITION BY p.product_category_name_english) AS diff_from_category_avg
FROM orders o
JOIN items i ON o.order_id = i.order_id
JOIN products p ON i.product_id = p.product_id;


-- ============================================================
-- H. Advanced / Funnel-Specific Synthesis
-- ============================================================

-- Q38: Combining JOIN + CTE + CASE, show per-month funnel conversion rate
--      from "Placed" to "Delivered."
WITH monthly_funnel AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
        COUNT(*) AS placed,
        SUM(CASE WHEN order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END) AS delivered
    FROM orders
    GROUP BY order_month
)
SELECT
    order_month,
    placed,
    delivered,
    ROUND(100.0 * delivered / placed, 2) AS pct_placed_to_delivered
FROM monthly_funnel
ORDER BY order_month;


-- Q39: Combining window functions and filtering, identify the top 3 product categories
--      with the steepest month-over-month revenue decline.
WITH monthly_category_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        p.product_category_name_english AS category,
        SUM(i.item_revenue) AS revenue
    FROM orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN products p ON i.product_id = p.product_id
    GROUP BY order_month, category
),
revenue_change AS (
    SELECT
        *,
        LAG(revenue) OVER (PARTITION BY category ORDER BY order_month) AS prev_month_revenue
    FROM monthly_category_revenue
)
SELECT
    category,
    order_month,
    revenue,
    prev_month_revenue,
    ROUND(100.0 * (revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0), 2) AS pct_change
FROM revenue_change
WHERE prev_month_revenue IS NOT NULL AND revenue < prev_month_revenue
ORDER BY pct_change ASC
LIMIT 3;
