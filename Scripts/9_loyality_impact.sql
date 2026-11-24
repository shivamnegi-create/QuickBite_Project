/*9. Loyalty Impact: Among customers who placed five or more orders before the
crisis, determine how many stopped ordering during the crisis, and out of those,
how many had an average rating above 4.5?*/
WITH customers_orders AS (
	SELECT 
	fo.customer_id,
	count(CASE WHEN fo.order_date BETWEEN '2025-01-01' AND '2025-05-31' 
			   THEN fo.order_id 
			   END ) AS pre_crisis_orders,
	count(CASE WHEN fo.order_date BETWEEN '2025-06-01' AND '2025-09-30'
	           THEN fo.order_id 
	           END ) AS crisis_orders,
	round(
	       (
	         avg
	             (
	                   CASE WHEN fo.order_date BETWEEN '2025-01-01' AND '2025-05-31'
	                   THEN fr.rating 
	                   END 
	             )
	        ) :: NUMERIC , 2
	        ) AS avg_rating
	
	FROM  fact_orders fo
	LEFT JOIN fact_ratings fr  ON fo.order_id = fr.order_id 
	GROUP BY fo.customer_id
	)
	SELECT 
	count(*) AS customers_stopped,
	count(CASE WHEN avg_rating > 4.5
	           THEN customer_id
	           END ) AS "above_4.5_rating"
	FROM customers_orders 
	WHERE pre_crisis_orders >= 5 AND crisis_orders = 0