SELECT COUNT(*)
FROM app_store_apps;

SELECT COUNT(*)
FROM play_store_apps;

SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;

SELECT *
FROM app_store_apps INNER JOIN play_store_apps ON app_store_apps.name = play_store_apps.name
WHERE price::money::numeric = 0

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
			ELSE 0 END AS projected_lifespan_in_years
	   
FROM app_store_apps;


--playstore apps name, initial cost
SELECT name,
	   price,
	   CASE WHEN price::money::decimal =  0 THEN '10000'
	        WHEN price::money::decimal <= 1 THEN '10000'
	        WHEN price::money::decimal > 1 THEN price::money::decimal*10000
	        ELSE 0 END AS initial_cost,
	   rating,
	   CASE WHEN rating = 0 THEN '1'
	        WHEN rating <= 0.9 THEN '2'
			WHEN rating <= 1.4 THEN '3'
			WHEN rating <= 1.9 THEN '4'
			WHEN rating <= 2.4 THEN '5'
			WHEN rating <= 2.9 THEN '6'
			WHEN rating <= 3.4 THEN '7'
			WHEN rating <= 3.9 THEN '8'
			WHEN rating <= 4.4 THEN '9'
			WHEN rating <= 4.9 THEN '10'
			WHEN rating = 5 THEN '11'
			ELSE 0 END AS projected_lifespan_in_years
	   
FROM play_store_apps;


--union tables?
SELECT name,
	   price,
	   review_count::numeric,
	   rating,
	   content_rating,
	   primary_genre
FROM app_store_apps
UNION
SELECT name,
	   price::money::numeric,
	   review_count,
	   rating::numeric,
	   content_rating,
	   genres
FROM play_store_apps;