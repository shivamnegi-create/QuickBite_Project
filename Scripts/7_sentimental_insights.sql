/*7. Sentiment Insights: During the crisis period, identify the most frequently
occurring negative keywords in customer review texts. */

WITH total_words AS (
	SELECT 
	regexp_split_to_table(lower(review_text ), '[^a-z]+') AS words,
	count(*) AS frequency
	
	FROM fact_ratings fr
	JOIN fact_orders fo  ON fo.order_id = fr.order_id 
	WHERE order_date BETWEEN '2025-06-01' AND '2025-09-30'
	GROUP BY words
	)
	
	SELECT 
	
	*
	
	FROM total_words 
	WHERE words IN (
    'late',
    'cold',
    'bad',
    'poor',
    'terrible',
    'horrible',
    'worst',
    'stale',
    'issue'
)
ORDER BY frequency DESC 
