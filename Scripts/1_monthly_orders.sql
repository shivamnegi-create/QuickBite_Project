/*1. Monthly Orders: Compare total orders across pre-crisis (Jan-May 2025) vs crisis
(Jun-Sep 2025). How severe is the decline?*/

WITH order_count AS (
	SELECT 
	count(CASE WHEN order_date BETWEEN '01-01-2025' AND '31-05-2025' THEN order_id END ) AS total_orders_pre_crisis,
	count(CASE WHEN order_date BETWEEN '01-06-2025' AND '30-09-2025' THEN order_id END ) AS total_orders_crisis
	
	FROM fact_orders 
	)
	
	SELECT 
	total_orders_pre_crisis ,
	total_orders_crisis ,
	total_orders_pre_crisis - total_orders_crisis AS difference,
	100.0 * (total_orders_pre_crisis - total_orders_crisis) / total_orders_pre_crisis AS percentage_decline 
	
	FROM order_count 
