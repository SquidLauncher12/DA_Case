{{ config(materialized='table') }}

SELECT
    unique_id,
    TO_TIMESTAMP(tpeppickupdatetime / 1000000000.0) AS pickup_timestamp,
    TO_TIMESTAMP(tpepdropoffdatetime / 1000000000.0) AS dropoff_timestamp
FROM raw_taxi_trips
ORDER BY unique_id
