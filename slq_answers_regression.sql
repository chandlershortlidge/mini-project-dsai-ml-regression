CREATE DATABASE IF NOT EXISTS house_price_regression;
USE house_price_regression;

DROP TABLE IF EXISTS house_price_data;

CREATE TABLE house_price_data (
    id BIGINT,
    date VARCHAR(20),
    bedrooms INT,
    bathrooms DECIMAL(3,2),
    sqft_living INT,
    sqft_lot INT,
    floors DECIMAL(3,1),
    waterfront INT,
    `view` INT,
    `condition` INT,
    grade INT,
    sqft_above INT,
    sqft_basement INT,
    yr_built INT,
    yr_renovated INT,
    zipcode INT,
    lat DECIMAL(8,4),
    `long` DECIMAL(8,4),
    sqft_living15 INT,
    sqft_lot15 INT,
    price INT
);

select * from house_price_data;

alter table house_price_data
drop `date`;

select * from house_price_data
limit 10;

select count(*) as row_count
from house_price_data;
-- 21597

-- What are the unique values in the column bedrooms?
select distinct bedrooms
from house_price_data
order by bedrooms;

-- What are the unique values in the column bathrooms?
select distinct bathrooms
from house_price_data
order by bathrooms;

-- What are the unique values in the column floors?
select distinct floors
from house_price_data
order by floors;

-- What are the unique values in the column condition?
select distinct `condition`
from house_price_data
order by `condition`;

-- What are the unique values in the column grade?
select distinct grade
from house_price_data
order by grade;

-- Arrange the data in a decreasing order by the price of the house. 
-- Return only the IDs of the top 10 most expensive houses in your data.

select id, price 
from house_price_data
order by price desc
limit 10;

-- What is the average price of all the properties in your data?
select avg(price) as "Average Price"
from house_price_data;
-- $540,296.57

-- What is the average price of the houses grouped by bedrooms? 
-- The returned result should have only two columns, bedrooms and Average of the prices. 
-- Use an alias to change the name of the second column.

select round(avg(price),2) as "Average Price", bedrooms as Bedrooms
from house_price_data
group by bedrooms
order by bedrooms;

-- What is the average sqft_living of the houses grouped by bedrooms? 

select round(avg(sqft_living), 2) as "Average Sqft", bedrooms as Bedrooms
from house_price_data
group by bedrooms
order by bedrooms; 

-- What is the average price of the houses with a waterfront and without a waterfront?
select round(avg(price),2) as "Average Price", waterfront as Waterfront
from house_price_data
group by waterfront;
-- no = $531,762.32
-- yes = $1,662,524.18

-- is there any correlation between the columns condition and grade?
-- You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column.

select `condition` as "Condition", round(avg(grade),2) as "Average Grade"
from house_price_data
group by `condition`
order by `condition`;

-- Condition 1-3 shows a clear upward trend
-- Condition 4-5 plateau or slightly decline
-- weak positive correlation

-- One of the customers is only interested in the following houses:
select * 
from house_price_data
where price < 300000 
and bathrooms > 3 
and waterfront = 0 
and floors = 1 
and `condition` >= 3
and grade >= 5 
and (bedrooms = 3 or bedrooms = 4);

-- list of properties whose prices are twice more than the average of all the properties in the database.
select *
from house_price_data
where price > 2 * (select avg(price) from house_price_data);

-- find out the list of properties whose prices are twice more than the average

create view twice_avg_price as 
select *
from house_price_data
where price > 2 * (select avg(price) from house_price_data);

-- Most customers are interested in properties with three or four bedrooms. 
-- What is the difference in average prices of the properties with three and four bedrooms?

SELECT 
    (SELECT AVG(price) FROM house_price_data WHERE bedrooms = 4) -
    (SELECT AVG(price) FROM house_price_data WHERE bedrooms = 3) 
    AS "Price Difference";

-- What are the different locations where properties are available in your database? (distinct zip codes)
select distinct zipcode
from house_price_data;

-- Show the list of all the properties that were renovated.
select * from house_price_data
where yr_renovated != 0;

-- Provide the details of the property that is the 11th most expensive property in your database.

SELECT * 
FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;



