/*2. Which top 5 city groups experienced the highest percentage decline in orders
during the crisis period compared to the pre-crisis period?*/

WITH order_count AS (
	SELECT 
	dr.city,
	count(CASE WHEN fo.order_date BETWEEN '01-01-2025' AND '31-05-2025' THEN order_id END ) AS total_orders_pre_crisis,
		count(CASE WHEN fo.order_date BETWEEN '01-06-2025' AND '30-09-2025' THEN order_id END ) AS total_orders_crisis
	
	FROM fact_orders fo 
	LEFT JOIN  dim_restaurant dr ON fo.restaurant_id = dr.restaurant_id
	GROUP BY dr.city 
	), order_decline AS (
	SELECT 
	city,
	total_orders_pre_crisis,
	total_orders_crisis,
	round((100.0 * (total_orders_pre_crisis  - total_orders_crisis) / NULLIF (total_orders_pre_crisis, 0 ) ), 2 ) AS percentage_decline
	
	FROM order_count 
	), rank_analysis AS (
	SELECT 
	*,
	rank() over(ORDER BY percentage_decline desc) AS rnk
	
	FROM order_decline 
	)
	SELECT 
	
	*
	
	FROM rank_analysis 
	WHERE rnk <=5