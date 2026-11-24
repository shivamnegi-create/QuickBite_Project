/*4. Cancellation Analysis: What is the cancellation rate trend pre-crisis vs crisis,
and which cities are most affected?*/
WITH cancelled_orders AS (
	SELECT
	    dr.city,
	
	    COUNT(CASE
	            WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31'
	            THEN order_id
	          END) AS pre_crisis_orders,
	
	    COUNT(CASE
	            WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31'
	             AND is_cancelled = 'Y'
	            THEN order_id
	          END) AS pre_crisis_cancelled,
	
	    COUNT(CASE
	            WHEN order_date BETWEEN '2025-06-01' AND '2025-09-30'
	            THEN order_id
	          END) AS crisis_orders,
	
	    COUNT(CASE
	            WHEN order_date BETWEEN '2025-06-01' AND '2025-09-30'
	             AND is_cancelled = 'Y'
	            THEN order_id
	          END) AS crisis_cancelled
	FROM fact_orders fo
	JOIN dim_restaurant dr
	ON fo.restaurant_id = dr.restaurant_id
	GROUP BY dr.city
), cancellation_rates AS (
SELECT 
city,
round((100.0 * pre_crisis_cancelled / NULLIF (pre_crisis_orders, 0 )),2) AS pre_rate,
round((100.0 * crisis_cancelled / NULLIF (crisis_orders, 0 )), 2 ) AS crisis_rate

FROM cancelled_orders 
)
SELECT 
city,
pre_rate ,
crisis_rate ,
crisis_rate  - pre_rate  AS difference 
FROM cancellation_rates 
ORDER BY difference DESC 