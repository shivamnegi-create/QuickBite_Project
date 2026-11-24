/*5. Delivery SLA: Measure average delivery time across phases. Did SLA
compliance worsen significantly in the crisis period?*/

SELECT 
CASE WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-Crisis' 
					ELSE 'Crisis' 
					END AS phase ,
round ((avg(fd.actual_delivery_time_mins )),2) AS avg_delivery_time,
round((100.0 * count(CASE WHEN fd.actual_delivery_time_mins < fd.expected_delivery_time_mins  THEN fd.order_id END )
  	/ count(*)),2) AS "sla_compliance_%"


FROM fact_delivery_performance fd
JOIN fact_orders fo ON fo.order_id = fd.order_id 
GROUP BY phase 
ORDER BY phase DESC 