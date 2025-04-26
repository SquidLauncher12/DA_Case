SELECT *
FROM {{ref('fact_taxi_trips')}}
WHERE duration_minutes <= 0