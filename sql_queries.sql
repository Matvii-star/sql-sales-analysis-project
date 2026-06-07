-- row counts
SELECT COUNT(*) FROM list_orders;
SELECT COUNT(*) FROM order_details;
SELECT COUNT(*) FROM sales_target;

-- null values
SELECT COUNT(*) FROM sales_target
WHERE month_of_order_date IS NULL
OR category IS NULL
OR target IS NULL;

SELECT COUNT(*) FROM list_orders
WHERE order_id IS NULL
OR order_date IS NULL
OR customer_name IS NULL
OR state IS NULL
OR city IS NULL;

SELECT COUNT(*) FROM order_details
WHERE order_id IS NULL
OR amount IS NULL
OR profit IS NULL
OR quantity IS NULL
OR category IS NULL
OR sub_category IS NULL;

-- orphan records
SELECT od.*
FROM order_details od
LEFT JOIN list_orders lo
    ON od.order_id = lo.order_id
WHERE
    lo.order_id IS NULL;

-- total revenue, profit, orders
SELECT 
	SUM(amount) as total_revenue,
	SUM(profit) as total_profit,
	COUNT(DISTINCT order_id) as total_orders
FROM order_details;

-- average order value
SELECT ROUND(AVG(order_value),2) AS average_order_value 
FROM (SELECT order_id, SUM(amount) as order_value 
	 FROM order_details
	 GROUP BY order_id);

-- revenue by category
SELECT 
	category, 
	SUM(amount) AS revenue,
	SUM(profit) AS profit 
FROM order_details
GROUP BY category
ORDER BY revenue DESC;

-- best sub-categories
SELECT 
	sub_category, 
	SUM(amount) AS revenue 
FROM order_details
GROUP BY sub_category
ORDER BY revenue DESC
LIMIT 10;

-- top customers by revenue
SELECT 
	lo.customer_name, 
	SUM(od.amount) AS revenue,
	SUM(od.profit) AS profit,
	COUNT(DISTINCT lo.order_id) AS orders
FROM list_orders lo
JOIN order_details od ON lo.order_id = od.order_id
GROUP BY lo.customer_name
ORDER BY revenue DESC;

-- analysis by state
SELECT 
	lo.state, 
	SUM(od.amount) AS revenue, 
	SUM(od.profit) as profit, 
	COUNT(DISTINCT lo.order_id) as orders
FROM list_orders lo
JOIN order_details od ON lo.order_id = od.order_id
GROUP BY lo.state
ORDER BY revenue DESC;

-- analysis by city
SELECT 
	lo.city, 
	SUM(od.amount) AS revenue, 
	SUM(od.profit) as profit, 
	COUNT(DISTINCT lo.order_id) as orders
FROM list_orders lo
JOIN order_details od ON lo.order_id = od.order_id
GROUP BY lo.city
ORDER BY revenue DESC;

--target achievement by category
WITH revenue_by_category AS (
    SELECT
        category,
        SUM(amount) AS total_revenue
    FROM order_details
    GROUP BY category
),

target_by_category AS (
    SELECT
        category,
        SUM(target) AS total_target
    FROM sales_target
    GROUP BY category
)

SELECT
    r.category,
    r.total_revenue,
    t.total_target,
    ROUND(r.total_revenue * 100.0 / t.total_target, 2) AS achievement_pct,
    r.total_revenue - t.total_target AS variance
FROM revenue_by_category r
JOIN target_by_category t
    ON r.category = t.category
ORDER BY variance DESC;

-- revenue, profit, orders by month
SELECT 
	DATE_TRUNC('month', order_date) as order_month, 
	SUM(amount) as total_revenue, 
	SUM(profit) as total_profit,
	COUNT(DISTINCT l.order_id) AS total_orders
FROM list_orders l
JOIN order_details o ON l.order_id = o.order_id
GROUP BY order_month
ORDER by order_month;

-- sales target analysis
WITH orders_date AS
(SELECT 
	DATE_TRUNC('month', order_date) as order_month,
	category,
	SUM(amount) as total_revenue
FROM list_orders l
JOIN order_details o ON l.order_id = o.order_id
GROUP BY order_month, category)

SELECT 
	month_of_order_date, 
	o.category, 
	total_revenue, 
	target,
	ROUND(total_revenue * 100.0 / target, 2) AS achievement_pct
FROM sales_target s
JOIN orders_date o ON o.order_month = s.month_of_order_date
AND o.category=s.category;

-- revenue ranking
WITH customer_revenue AS
(SELECT 
	lo.customer_name, 
	SUM(od.amount) AS revenue
FROM list_orders lo
JOIN order_details od ON lo.order_id = od.order_id
GROUP BY lo.customer_name)

SELECT 
	customer_name,
	RANK() OVER (ORDER BY revenue DESC) AS rank_num,
	revenue
FROM customer_revenue;

-- top cities ranked by sales
WITH city_revenue AS
(SELECT lo.city, SUM(od.amount) AS revenue
FROM list_orders lo
JOIN order_details od ON lo.order_id = od.order_id
GROUP BY lo.city)

SELECT 
	city,
	DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rank_num,
	revenue
FROM city_revenue;

-- revenue MoM
WITH orders_date AS
(SELECT 
	DATE_TRUNC('month', order_date) as order_month,
	SUM(amount) as total_revenue
FROM list_orders l
JOIN order_details o ON l.order_id = o.order_id
GROUP BY order_month),

lag_revenue AS(
SELECT
	order_month,
	total_revenue,
	LAG(total_revenue) OVER (ORDER BY order_month) as prev_month_revenue
FROM orders_date
)

SELECT 
	order_month,
	total_revenue,
	total_revenue - prev_month_revenue AS revenue_change,
	ROUND((total_revenue - prev_month_revenue)/prev_month_revenue * 100,2) as growth_pct
FROM lag_revenue;