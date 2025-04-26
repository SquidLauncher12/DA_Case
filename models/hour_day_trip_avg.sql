{{config(materialized='table')}}

SELECT
    pickup_day_of_week,
    pickup_hour_of_day,
    AVG(duration_minutes) AS average_trip_duration
FROM {{ref('fact_taxi_trips')}}
GROUP BY
    pickup_hour_of_day,
    pickup_day_of_week
ORDER BY
    CASE pickup_day_of_week
        WHEN 'Mon' THEN 1
        WHEN 'Tue' THEN 2
        WHEN 'Wed' THEN 3
        WHEN 'Thu' THEN 4
        WHEN 'Fri' THEN 5
        WHEN 'Sat' THEN 6
        WHEN 'Sun' THEN 7
    END,
    pickup_hour_of_day