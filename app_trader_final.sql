/*SELECT *
FROM play_store_apps;


--filter by category, rating, and price in play store
WITH playstore AS (SELECT DISTINCT(name), 
	  			   ROUND(AVG(rating), 2) AS avg_rating, 
	   			   SUM(review_count) AS sum_review_count
				   FROM play_store_apps
				   WHERE category ILIKE '%game%'
   					     AND rating::numeric > 4.0
	  					 AND price::money::numeric = 0
	  					 AND review_count > 10000
				   GROUP BY name
				   ORDER BY sum_review_count DESC)
SELECT name, 
	   appstore.rating AS appstore_rating, 
	   appstore.review_count AS appstore_review_count,
	   playstore.avg_rating AS playstore_avg_rating,
	   playstore.sum_review_count AS playstore_sum_review_count
FROM app_store_apps AS appstore FULL JOIN playstore USING (name)
WHERE primary_genre ILIKE '%games%'
      AND rating > 4.0
	  AND price = 0
	  AND review_count::numeric > 100000
ORDER BY name;


WITH playstore AS (SELECT DISTINCT(name), 
	  			   ROUND(AVG(rating), 2) AS avg_rating, 
	   			   SUM(review_count) AS sum_review_count,
				   category
				   FROM play_store_apps
				   WHERE rating::numeric > 4.0
	  					 AND price::money::numeric = 0
	  					 AND review_count > 10000
				   GROUP BY name, category
				   ORDER BY sum_review_count DESC)
SELECT name, 
	   appstore.rating AS appstore_rating, 
	   appstore.review_count AS appstore_review_count,
	   appstore.primary_genre AS appstore_genre,
	   playstore.avg_rating AS playstore_avg_rating,
	   playstore.sum_review_count AS playstore_sum_review_count,
	   playstore.category AS playstore_genre
FROM app_store_apps AS appstore FULL JOIN playstore USING (name)
WHERE rating > 4.0
	  AND price = 0
	  AND review_count::numeric > 100000
ORDER BY name;










--
--SELECT name, 
--       CASE WHEN price = 0 THEN '10000'
--	        WHEN price <= 1 THEN '10000'
--	        WHEN price >1 THEN price*10000
--	        ELSE 0 END AS initial_cost,
--	   rating*2+1 AS projected_lifespan_years,
--	   ((initial_cost+(projected_lifespan_years/12*1000))-((projected_lifespan_years/12)*5000)) AS projected_income
--FROM app_store_apps;
*/



WITH calc_app AS (SELECT name,
						 CASE WHEN price = 0 THEN '10000'
	       					  WHEN price <= 1 THEN '10000'
	        				  WHEN price >1 THEN price*10000
	        				  ELSE 0 END AS initial_cost_app,
						 rating*2+1 AS projected_lifespan_years_app,
				         primary_genre,
				  		 rating,
				  		 content_rating
				  FROM app_store_apps
				  WHERE rating > 4.5
				        AND price = 0
				        AND content_rating ILIKE '%4+%'),
				 		--AND primary_genre ILIKE '%games%'),
	 calc_play AS (SELECT name,
						  CASE WHEN price::money::numeric =  0 THEN 10000
	        			  WHEN price::money::numeric <= 1 THEN 10000
	          			  WHEN price::money::numeric > 1 THEN price::money::decimal*10000
	        			  ELSE 0 END AS initial_cost_play,
				          ROUND(rating*2+1, 1) AS projected_lifespan_years_play,
				   		  genres,
				   		  rating,
				   		  content_rating
				   FROM play_store_apps
				   WHERE rating > 4.5
				         AND price::money::numeric = 0
				         AND content_rating ILIKE '%everyone%')
				  		-- AND genres ILIKE '%game')
SELECT name,
	   ROUND(((initial_cost_app+((projected_lifespan_years_app/12)*1000))-((projected_lifespan_years_app/12)*5000))*12*projected_lifespan_years_app, 2) AS projected_income,
      content_rating,
	   primary_genre
FROM calc_app
UNION
SELECT name,
	   ROUND(((initial_cost_play+((projected_lifespan_years_play/12)*1000))-((projected_lifespan_years_play/12)*5000))*12*projected_lifespan_years_play, 2) AS projected_income,
	   content_rating,
	   genres
FROM calc_play
ORDER BY projected_income DESC

