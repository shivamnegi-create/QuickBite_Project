/*8. Revenue Impact: Estimate revenue loss from pre-crisis vs crisis (based on
subtotal, discount, and delivery fee).*/

WITH revenue AS (
	SELECT
		sum(CASE 
			WHEN order_date BETWEEN '2025-01-01' AND '2025-05-31' 
			THEN subtotal_amount - discount_amount + delivery_fee 
			END) pre_crisis_revenue,
		sum(CASE 
			WHEN order_date BETWEEN '2025-06-01' AND '2025-09-30' 
			THEN subtotal_amount - discount_amount + delivery_fee 
			END) crisis_revenue
	FROM
		fact_orders
		)
		SELECT 
		pre_crisis_revenue ,
		crisis_revenue,
		pre_crisis_revenue - crisis_revenue AS revenue_lost,
		round((100.0 * ( pre_crisis_revenue - crisis_revenue ) /NULLIF (pre_crisis_revenue, 0 ) ) :: NUMERIC  , 2 ) AS "%_decline_in_revenue"
		
		FROM revenue 
