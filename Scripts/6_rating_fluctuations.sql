/*6. Ratings Fluctuation: Track average customer rating month-by-month. Which
months saw the sharpest drop?*/
WITH average_rating AS (
	SELECT 
	date_trunc('Month', fo.order_date ) :: date AS order_month,
	round((avg(fr.rating )):: NUMERIC , 2) AS avg_rating
	
	FROM fact_ratings fr 
	JOIN fact_orders fo  ON fo.order_id  = fr.order_id 
	GROUP BY order_month 
	)
	
	SELECT 
	to_char(order_month,'Mon-YYYY') AS month,
	avg_rating,
	avg_rating - lag(avg_rating ) over(ORDER BY order_month) AS difference 
	
	FROM average_rating
	ORDER BY difference 