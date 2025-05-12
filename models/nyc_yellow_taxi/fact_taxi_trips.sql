{{ config(materialized='table') }}

WITH rides AS(
    SELECT
        unique_id,
        TO_TIMESTAMP(tpeppickupdatetime / 1000000000.0) AS pickup_timestamp,
        TO_TIMESTAMP(tpepdropoffdatetime / 1000000000.0) AS dropoff_timestamp
    FROM raw_taxi_trips
),

trip_duration AS(
    SELECT
        unique_id, pickup_timestamp, dropoff_timestamp,
        ROUND(ABS(DATEDIFF('SECOND', dropoff_timestamp, pickup_timestamp)/60.0),2) AS duration_minutes
    FROM rides
),

hour_and_day AS (
    SELECT
        unique_id,
        pickup_timestamp,
        EXTRACT(HOUR FROM pickup_timestamp) AS pickup_hour_of_day,
        DAYNAME(pickup_timestamp) AS pickup_day_of_week,
        dropoff_timestamp,
        EXTRACT(HOUR FROM dropoff_timestamp) AS dropoff_hour_of_day,
        DAYNAME(pickup_timestamp) AS dropoff_day_of_week
    FROM rides
),
final AS(
    SELECT
        rides.unique_id,
        rides.pickup_timestamp,
        rides.dropoff_timestamp,
        trip_duration.duration_minutes,
        hour_and_day.pickup_hour_of_day,
        hour_and_day.pickup_day_of_week,
        hour_and_day.dropoff_hour_of_day,
        hour_and_day.dropoff_day_of_week
    FROM rides
    LEFT JOIN trip_duration ON rides.unique_id = trip_duration.unique_id
    LEFT JOIN hour_and_day ON rides.unique_id = hour_and_day.unique_id
)
SELECT *
FROM final
ORDER BY unique_id ASC
