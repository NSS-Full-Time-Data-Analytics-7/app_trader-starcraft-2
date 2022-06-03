SELECT COUNT(distinct primary_genre)
FROM app_store_apps;

--app store apps
SELECT name,
	   price,
	   CASE WHEN price = 0 THEN '10000'
	        WHEN price <= 1 THEN '10000'
	        WHEN price >1 THEN price*10000
	        ELSE 0 END AS initial_cost,
	   rating,
	   CASE WHEN rating = 0 THEN '1'
	        WHEN rating = 0.5 THEN '2'
			WHEN rating = 1.0 THEN '3'
			WHEN rating = 1.5 THEN '4'
			WHEN rating = 2.0 THEN '5'
			WHEN rating = 2.5 THEN '6'
			WHEN rating = 3.0 THEN '7'
			WHEN rating = 3.5 THEN '8'
			WHEN rating = 4.0 THEN '9'
			WHEN rating = 4.5 THEN '10'
			WHEN rating = 5.0 THEN '11'
			ELSE 0 END AS projected_lifespan_in_years,
			primary_genre,
			review_count
	   
FROM app_store_apps
WHERE rating >= 4.0
      AND review_count::numeric > 10000
	  AND price =0
	  AND primary_genre ILIKE 'games'
ORDER BY review_count::numeric DESC;

SELECT COUNT(DISTINCT price)
FROM app_store_apps
