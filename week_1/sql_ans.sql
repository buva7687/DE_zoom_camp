-- Question 3: How many taxi trips were there on January 15?
SELECT count(1) AS total_taxi_trips_on_jan15
FROM yellow_taxi_trips
WHERE (cast(tpep_pickup_datetime AS DATE)) = '2021-01-15'
;

-- Question 4: On which day it was the largest tip in January?
SELECT cast(tpep_pickup_datetime AS DATE) AS largest_tip_date
FROM yellow_taxi_trips
WHERE tip_amount IN (
		SELECT max(tip_amount)
		FROM yellow_taxi_trips
		);

-- Question 5: Most popular destination. What was the most popular destination for passengers picked up in central park on January 14? Enter the zone name (not id).
-- If the zone name is unknown (missing), write "Unknown"
SELECT Popular_Destination from
(SELECT CASE
			WHEN zd."Zone" IS NULL
				THEN 'Unknown'
			ELSE zd."Zone"
			END AS Popular_Destination,
		count(*) AS total_trips
	FROM yellow_taxi_trips t
	INNER JOIN zone_lookup zp ON t."PULocationID" = zp."LocationID"
	INNER JOIN zone_lookup zd ON t."DOLocationID" = zd."LocationID"
	WHERE zp."Zone" LIKE 'Central Park'
		AND (cast(tpep_pickup_datetime AS DATE)) = '2021-01-14'
	GROUP BY 1
	ORDER BY total_trips DESC
 limit 1
	) sub
;


-- Question 6: Most expensive route.
-- What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?
-- Enter two zone names separated by a slashFor example:"Jamaica Bay / Clinton East"If any of the zone names are unknown (missing),
-- write "Unknown". For example, "Unknown / Clinton East".

select pickup_location || '/' || drop_off_location
from
(
SELECT CASE
			WHEN zp."Zone" IS NULL
				THEN 'Unknown'
			ELSE zp."Zone"
			END AS pickup_location
      ,CASE
      			WHEN zd."Zone" IS NULL
      				THEN 'Unknown'
      			ELSE zd."Zone"
      			END AS drop_off_location
, Avg(total_amount) as tot
FROM yellow_taxi_trips t
	INNER JOIN zone_lookup zp ON t."PULocationID" = zp."LocationID"
	INNER JOIN zone_lookup zd ON t."DOLocationID" = zd."LocationID"
	group by 1,2
	order by 3 desc
	limit 1
	) sub
	;
