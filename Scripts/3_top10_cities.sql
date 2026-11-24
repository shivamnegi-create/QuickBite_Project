n/*3. Among restaurants with at least 50 pre-crisis orders, which top 10 high-volume
restaurants experienced the largest percentage decline in order counts during
the crisis period?*/

WITH order_count AS (
	SELECT 
	dr.restaurant_name,
	count(CASE WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31' THEN order_id END ) AS pre_crisis_orders,
	count(CASE WHEN order_date BETWEEN '2025-06-01' AND '2025-09-30' THEN order_id END ) AS crisis_orders
	FROM fact_orders fo 
	JOIN dim_restaurant dr ON fo.restaurant_id = dr.restaurant_id 
	GROUP BY dr.restaurant_name 
	),percentage_analysis AS (
	SELECT 
	*,
	round ((100.0 * (pre_crisis_orders - crisis_orders) / NULLIF(pre_crisis_orders , 0) ),2)  AS percentage_decline 
	
	FROM order_count 
	WHERE pre_crisis_orders >= 50
	), rank_analysis AS (
	SELECT 
	*,
	rank() over(ORDER BY percentage_decline desc) AS rnk
	
	FROM percentage_analysis 
	)
	SELECT 
	restaurant_name ,
	pre_crisis_orders ,
	crisis_orders ,
	percentage_decline 
	
	FROM rank_analysis 
	WHERE rnk <=10