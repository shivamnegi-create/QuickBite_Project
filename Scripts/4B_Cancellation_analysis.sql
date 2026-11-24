/*4. Cancellation Analysis: What is the cancellation rate trend pre-crisis vs crisis,
and which cities are most affected?*/

WITH orders_count AS (
	SELECT 
	date_trunc('Month', order_date):: date AS MONTH,
	count(CASE WHEN is_cancelled = 'Y' THEN order_id END ) AS cancelled_orders,
	count(order_id) AS total_orders
	
	
	FROM fact_orders 
	GROUP BY MONTH 
	)
	
	SELECT 
	to_char(MONTH, 'Mon-YYYY') AS month,
	round ((100.0 * cancelled_orders / total_orders),2) AS cancellation_rate
	
	
	FROM orders_count 