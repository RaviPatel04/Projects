-- Database: corona_virus

-- DROP DATABASE IF EXISTS corona_virus;

CREATE DATABASE corona_virus
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE TABLE corona_virus_data (
    Province TEXT,
    Country_Region TEXT,
    Latitude DOUBLE PRECISION,
    Longitude DOUBLE PRECISION,
    Date DATE,
    Confirmed INTEGER,
    Deaths INTEGER,
    Recovered INTEGER
);


SELECT * FROM corona_virus_data

-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT 
    COUNT(*) - COUNT(province) AS Province_NULLs,
    COUNT(*) - COUNT(country_region) AS Country_Region_NULLs,
    COUNT(*) - COUNT(latitude) AS Latitude_NULLs,
    COUNT(*) - COUNT(longitude) AS Longitude_NULLs,
    COUNT(*) - COUNT(date) AS Date_NULLs,
    COUNT(*) - COUNT(confirmed) AS Confirmed_NULLs,
    COUNT(*) - COUNT(deaths) AS Deaths_NULLs,
    COUNT(*) - COUNT(recovered) AS Recovered_NULLs
FROM corona_virus_data;


--Q2. If NULL values are present, update them with zeros for all columns.
UPDATE corona_virus_data
SET 
    province = COALESCE(province, ''),
    country_region = COALESCE(country_region, ''),
    latitude = COALESCE(latitude, 0),
    longitude = COALESCE(longitude, 0),
    date = COALESCE(date, '1970-01-01'),  -- Assuming default date for missing values
    confirmed = COALESCE(confirmed, 0),
    deaths = COALESCE(deaths, 0),
    recovered = COALESCE(recovered, 0);



-- Q3. check total number of rows
SELECT COUNT(*) FROM corona_virus_data;


-- Q4. Check what is start_date and end_date
SELECT MIN(date) AS start_date, MAX(date) AS end_date FROM corona_virus_data;


-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT TO_CHAR(date, 'YYYY-MM')) AS months_count FROM corona_virus_data;


-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month,
    ROUND(CAST(AVG(confirmed)AS numeric), 1) AS avg_confirmed,
    ROUND(CAST(AVG(deaths)AS numeric), 1) AS avg_deaths,
    ROUND(CAST(AVG(recovered)AS numeric), 1) AS avg_recovered
FROM corona_virus_data
GROUP BY month
ORDER BY month;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month
WITH freq_values AS (
    SELECT 
        TO_CHAR(date, 'YYYY-MM') AS month,
        confirmed, deaths, recovered,
        ROW_NUMBER() OVER (PARTITION BY TO_CHAR(date, 'YYYY-MM') ORDER BY COUNT(*) DESC) AS rn
    FROM corona_virus_data
    GROUP BY month, confirmed, deaths, recovered
)
SELECT month, confirmed, deaths, recovered
FROM freq_values
WHERE rn = 1;


-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM corona_virus_data
GROUP BY year
ORDER BY year;


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered
FROM corona_virus_data
GROUP BY year
ORDER BY year;


-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
FROM corona_virus_data
GROUP BY month
ORDER BY month;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(confirmed) AS total_confirmed,
    ROUND(CAST(AVG(confirmed)AS numeric), 1) AS avg_confirmed,
    ROUND(CAST(VARIANCE(confirmed)AS numeric), 1) AS var_confirmed,
    ROUND(CAST(STDDEV(confirmed)AS numeric), 1) AS stdev_confirmed
FROM corona_virus_data;


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month,
    SUM(deaths) AS total_deaths,
    AVG(deaths) AS avg_deaths,
    VARIANCE(deaths) AS var_deaths,
    STDDEV(deaths) AS stdev_deaths
FROM corona_virus_data
GROUP BY month
ORDER BY month;


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(recovered) AS total_recovered,
    AVG(recovered) AS avg_recovered,
    VARIANCE(recovered) AS var_recovered,
    STDDEV(recovered) AS stdev_recovered
FROM corona_virus_data;


-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    country_region,
    SUM(confirmed) AS total_confirmed
FROM corona_virus_data
GROUP BY country_region
ORDER BY total_confirmed DESC
LIMIT 1;


-- Q15. Find Country having lowest number of the death case
SELECT 
    country_region,
    SUM(deaths) AS total_deaths
FROM corona_virus_data
GROUP BY country_region
ORDER BY total_deaths ASC
LIMIT 1;


-- Q16. Find top 5 countries having highest recovered case 
SELECT 
    country_region,
    SUM(recovered) AS total_recovered
FROM corona_virus_data
GROUP BY country_region
ORDER BY total_recovered DESC
LIMIT 5;


