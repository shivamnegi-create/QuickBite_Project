/*10. Customer Lifetime Decline: Which high-value customers (top 5% by total
spend before the crisis) showed the largest drop in order frequency and ratings
during the crisis? What common patterns (e.g., location, cuisine preference,
delivery delays) do they share?*/

WITH customer_spending AS (
	SELECT 
	fo.customer_id,
	 sum(CASE WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31' 
	          THEN fo.total_amount  
	          END) AS total_spend_before_crisis,
	 count(CASE WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31' THEN fo.order_id END ) AS pre_crisis_orders,
	count(CASE WHEN order_date BETWEEN '2025-06-01' AND '2025-09-30' THEN fo.order_id END ) AS crisis_orders,
	round(
	       (
	         avg
	             (
	                   CASE WHEN fo.order_date BETWEEN '2025-01-01' AND '2025-05-31'
	                   THEN fr.rating 
	                   END 
	             )
	        ) :: NUMERIC , 2
	        ) AS pre_crisis_avg_rating,
	        round(
	       (
	         avg
	             (
	                   CASE WHEN fo.order_date BETWEEN '2025-06-01' AND '2025-09-30'
	                   THEN fr.rating 
	                   END 
	             )
	        ) :: NUMERIC , 2
	        ) AS crisis_avg_rating
	
	
	FROM fact_orders fo 
	LEFT JOIN fact_ratings fr ON fr.order_id = fo.order_id 
	GROUP BY fo.customer_id 
	), top5 AS (
	SELECT  
	customer_id,
	total_spend_before_crisis, 
	round ((100.0 * (pre_crisis_orders - crisis_orders) / pre_crisis_orders), 2 ) AS "order_decline_%" ,
	pre_crisis_avg_rating - crisis_avg_rating AS rating_drop,
	ntile(20) over(ORDER BY total_spend_before_crisis desc  NULLS LAST ) AS rnk 
	
	
	FROM customer_spending
	)
	SELECT  
	customer_id,
	total_spend_before_crisis,
	"order_decline_%",
	rating_drop 
	
	FROM top5 
	WHERE rnk = 1 AND rating_drop IS NOT NULL 
 
	