-- Database: hotel_reservation

-- DROP DATABASE IF EXISTS hotel_reservation;

CREATE DATABASE hotel_reservation
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE TABLE hotel_reservations (
    Booking_ID VARCHAR PRIMARY KEY,
    no_of_adults INT,
    no_of_children INT,
    no_of_weekend_nights INT,
    no_of_week_nights INT,
    type_of_meal_plan VARCHAR,
    room_type_reserved VARCHAR,
    lead_time INT,
    arrival_date DATE,
    market_segment_type VARCHAR,
    avg_price_per_room FLOAT,
    booking_status VARCHAR
);


SELECT * FROM hotel_reservations

SELECT COUNT(*) AS total_reservations FROM hotel_reservations;


SELECT type_of_meal_plan, COUNT(*) AS count
FROM hotel_reservations
GROUP BY type_of_meal_plan
ORDER BY count DESC
LIMIT 1;


SELECT ROUND(CAST(AVG(avg_price_per_room) AS numeric), 2) AS avg_price_per_room_with_children
FROM hotel_reservations
WHERE no_of_children > 0;


SELECT COUNT(*) AS reservations_in_year
FROM hotel_reservations
WHERE EXTRACT(YEAR FROM arrival_date) = 2017;


SELECT room_type_reserved, COUNT(*) AS count
FROM hotel_reservations
GROUP BY room_type_reserved
ORDER BY count DESC
LIMIT 1;


SELECT COUNT(*) AS reservations_on_weekend
FROM hotel_reservations
WHERE no_of_weekend_nights > 0;


SELECT MAX(lead_time) AS max_lead_time, MIN(lead_time) AS min_lead_time
FROM hotel_reservations;


SELECT market_segment_type, COUNT(*) AS count
FROM hotel_reservations
GROUP BY market_segment_type
ORDER BY count DESC
LIMIT 1;


SELECT COUNT(*) AS confirmed_reservations
FROM hotel_reservations
WHERE booking_status = 'Not_Canceled';


SELECT SUM(no_of_adults) AS total_adults, SUM(no_of_children) AS total_children
FROM hotel_reservations;


SELECT ROUND(CAST(AVG(no_of_weekend_nights)AS numeric), 2) AS avg_weekend_nights_with_children
FROM hotel_reservations
WHERE no_of_children > 0;


SELECT EXTRACT(MONTH FROM arrival_date) AS month, COUNT(*) AS reservations_count
FROM hotel_reservations
GROUP BY month
ORDER BY month;


SELECT room_type_reserved, ROUND(CAST(AVG(no_of_weekend_nights + no_of_week_nights)AS numeric), 2) AS avg_nights
FROM hotel_reservations
GROUP BY room_type_reserved;


SELECT room_type_reserved, ROUND(CAST(AVG(avg_price_per_room)AS numeric), 2) AS avg_price
FROM hotel_reservations
WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT market_segment_type, ROUND(CAST(AVG(avg_price_per_room)AS numeric), 2) AS avg_price
FROM hotel_reservations
GROUP BY market_segment_type
ORDER BY avg_price DESC
LIMIT 1;






