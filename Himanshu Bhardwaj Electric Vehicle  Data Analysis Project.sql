CREATE DATABASE ELECTRIC_VEHICLE;
USE ELECTRIC_VEHICLE;


# DATA IMPORTATION IS DONE THROUGH COMMAND LINE
# NOW, LOOKING AT THE DATATYPES OF ALL THE COLUMNS
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'ELECTRIC_VEHICLE' 
AND table_name = 'VEHICLE'; 

# CORRECTING THE COLUMNS NAME
ALTER TABLE VEHICLE
CHANGE `2020 Census Tract` 2020_Census_Tract bigint,
CHANGE `Base MSRP` Base_MSRP INT,
CHANGE `Clean Alternative Fuel Vehicle (CAFV) Eligibility` Clean_Alternative_Fuel_Vehicle_Eligibility TEXT,
CHANGE `DOL Vehicle ID` DOL_Vehicle_ID INT,
CHANGE `Electric Range` Electric_Range INT,
CHANGE `Electric Utility` Electric_Utility TEXT,
CHANGE `Electric Vehicle Type` Electric_Vehicle_Type TEXT,
CHANGE `Legislative District` Legislative_District INT,
CHANGE `Model Year` Model_Year INT,
CHANGE `Vehicle Location` Vehicle_Location TEXT;

ALTER TABLE VEHICLE
CHANGE `VIN (1-10)` VIN TEXT;

# What is the average electric range of all the vehicles in the dataset?
SELECT AVG(Electric_Range) AS AVERAGE_ELECTRIC_RANGE 
FROM VEHICLE;

# Retrive the vehicle with "above average, below average , average" electric range with make and model. 
SELECT Make,Model, 
(CASE
    WHEN Electric_Range > 67.8631 THEN 'Above Average Range'
    WHEN Electric_Range = 67.8631 THEN 'Average Range'
	WHEN Electric_Range < 67.8631 THEN 'Below Average Range'
END) AS COMPARING_AVERAGE
FROM VEHICLE
GROUP BY Make,Model;

# Retrive the percentage of electric vehicles above average, average and below average electric range. 
WITH CategoryCounts AS (
    SELECT Make,Model,
        (CASE
            WHEN Electric_Range > 67.8631 THEN 'Above Average Range'
            WHEN Electric_Range = 67.8631 THEN 'Average Range'
            WHEN Electric_Range < 67.8631 THEN 'Below Average Range'
        END) AS COMPARING_AVERAGE
    FROM VEHICLE
    GROUP BY Make, Model, COMPARING_AVERAGE
)
SELECT
    COMPARING_AVERAGE,
    COUNT(*) AS Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS Percentage
FROM CategoryCounts
GROUP BY COMPARING_AVERAGE
ORDER BY COMPARING_AVERAGE;

 
# Retrive the percentage of electric vehicle types. 
SELECT Electric_Vehicle_Type,
       COUNT(*) AS Total_Count,
       (COUNT(*) / (SELECT COUNT(*) FROM VEHICLE)) * 100 AS Percentage
FROM VEHICLE
GROUP BY Electric_Vehicle_Type;

# Which city has the highest number of electric vehicles registered?
SELECT distinct CITY,COUNT(*) AS NUMBER_OF_VEHICLE FROM VEHICLE
GROUP BY CITY
ORDER BY NUMBER_OF_VEHICLE DESC
LIMIT 1;

#How many electric vehicles are eligible for Clean Alternative Fuel Vehicle (CAFV) incentives?
SELECT Clean_Alternative_Fuel_Vehicle_Eligibility , COUNT(*) AS NUMBER_OF_VEHICLES_CAFV_ELIGIBLE
FROM VEHICLE
WHERE Clean_Alternative_Fuel_Vehicle_Eligibility = 'Clean Alternative Fuel Vehicle Eligible'
GROUP BY Clean_Alternative_Fuel_Vehicle_Eligibility ;

# Calculate the total Base MSRP for all electric vehicles in the dataset.
SELECT distinct Model,Make,SUM(Base_MSRP) AS TOTAL_BASE_MSRP 
FROM VEHICLE 
GROUP BY Make,Model
ORDER BY TOTAL_BASE_MSRP DESC;

# Find the top 5 CITY with the most electric vehicles registered.
SELECT DISTINCT  City,COUNt(*) AS NUMBER_OF_ELECTRIC_VEHICLE
FROM VEHICLE
GROUP BY City
ORDER BY NUMBER_OF_ELECTRIC_VEHICLE DESC
LIMIT 5;

# Calculate the average Base MSRP of vehicles, result should be upto 2 decimals .
SELECT ROUND(AVG(Base_MSRP),2) AS AVERAGE_BASE_MSRP FROM VEHICLE;


# FETCH THE VEHICLES WITH ABOVE, BELOW AND AVERAGE BASE_MSRP WITH MAKE & MODEL. 
SELECT Model,Make,
(CASE
     WHEN Base_MSRP > 1311.2808 THEN 'Above Average Base_MSRP'
     WHEN Base_MSRP = 1311.2808 THEN 'Average Base_MSRP'
     WHEN Base_MSRP < 1311.2808 THEN 'Below Average Base_MSRP'
END) AS COMPARING_BASE_MSRP 
FROM VEHICLE
GROUP BY Model,Make;  

# Fetch  the percentage of vehicle above avergae base msrp, avergae base masrp & Below Average Base msrp.
WITH CategoryCounts AS (
    SELECt Make,Model,
        (CASE
     WHEN Base_MSRP > 1311.2808 THEN 'Above Average Base_MSRP'
     WHEN Base_MSRP = 1311.2808 THEN 'Average Base_MSRP'
     WHEN Base_MSRP < 1311.2808 THEN 'Below Average Base_MSRP'
END) AS COMPARING_BASE_MSRP 
FROM VEHICLE
GROUP BY Model,Make,COMPARING_BASE_MSRP 
)
SELECT
    COMPARING_BASE_MSRP ,
    COUNT(*) AS Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS Percentage
FROM CategoryCounts
GROUP BY COMPARING_BASE_MSRP 
ORDER BY COMPARING_BASE_MSRP ;


# How many electric vehicles have a Legislative District value of 10?
SELECT Make,Model, COUNT(*) AS NUMBER_OF_VEHICLE_LD_10
FROM VEHICLE
WHERE Legislative_District=10
GROUP  BY Make,Model
ORDER BY NUMBER_OF_VEHICLE_LD_10 DESC;

# List the Make and Model of vehicles with an Electric Range is atleast 300 miles.
SELECT make, model ,Electric_Range FROM VEHICLE
WHERE Electric_Range >=300
group by make,model
order by Electric_Range desc;

# Calculate the total number of electric vehicles in each Legislative District.
SELECT Legislative_District, Model,COUNT(*) AS TOTAL_ELECTRIC_VEHICLES
FROM VEHICLE
GROUP BY Legislative_District,Model
ORDER BY TOTAL_ELECTRIC_VEHICLES DESC;

# Find the City with the highest average Electric Range for its electric vehicles, result should be upto 2 decimals.
SELECT City , Round(AVG(Electric_Range),2) AS AVERAGE_ELECTRIC_RANGE
FROM VEHICLE
GROUP BY City
ORDER BY AVERAGE_ELECTRIC_RANGE DESC;

#  Find the all Model with Range, above average Electric Range for its electric vehicles. 
SELECT Model, Electric_Range FROM VEHICLE
WHERE Electric_Range >( SELECT AVG(Electric_Range) FROM VEHICLE)
GROUP BY Model
ORDER BY Electric_Range DESC ;

# List the top 10 most common Electric Utilities among electric vehicle owners
SELECT  Electric_Utility AS TOP_10_MOST_COMMON_ELECTRIC_UTILITIES , COUNT(*) AS Count_of_Electric_Utility
FROM VEHICLE
GROUP BY Electric_Utility
ORDER BY Count_of_Electric_Utility DESC
LIMIT 10;

# Calculate the total number of electric vehicles eligible for CAFV incentives in each City. 
SELECT City,Model, COUNT(*) AS NUMBER_OF_CAFV_ELIGIBLE_VEHICLES
FROM VEHICLE
WHERE Clean_Alternative_Fuel_Vehicle_Eligibility='Clean Alternative Fuel Vehicle Eligible'
GROUP BY City,Model
ORDER BY NUMBER_OF_CAFV_ELIGIBLE_VEHICLES DESC;

# Identify the Make and Model of vehicles with the highest and lowest Base MSRP. 
SELECT Make, Model, Base_MSRP
FROM VEHICLE
WHERE Base_MSRP = (SELECT MAX(Base_MSRP) FROM VEHICLE)
   OR Base_MSRP = (SELECT MIN(Base_MSRP) FROM VEHICLE)
GROUP BY Make, Model;

# Calculate the total number of electric vehicles by Model Year.
SELECT Model_Year, COUNT(*) AS NUMBER_OF_ELECTRIC_VEHICLE
FROM VEHICLE
GROUP BY Model_Year
ORDER BY NUMBER_OF_ELECTRIC_VEHICLE DESC;

# List the vehicles that have a Base MSRP higher than $50,000 and an Electric Range greater than 200 miles. 
SELECT Make,Model,Electric_Vehicle_Type,Base_MSRP,Electric_Range
FROM VEHICLE
WHERE Base_MSRP >= 50000 AND Electric_Range >= 200
GROUP BY Make,Model;

# Retrieve the models and electric ranges of vehicles that are eligible for CAFV incentives and have an electric range over 150 miles.
SELECT Model,Electric_Range,Clean_Alternative_Fuel_Vehicle_Eligibility
FROM VEHICLE
WHERE Electric_Range >=150 
AND Clean_Alternative_Fuel_Vehicle_Eligibility = 'Clean Alternative Fuel Vehicle Eligible'
GROUP BY Model;

# Find the electric vehicles located in legislative districts with a count of less than 10 vehicles.
SELECT Legislative_District,Model ,COUNT(*) AS NUMBER_OF_VEHICLE
FROM VEHICLE
GROUP BY Legislative_District,Model 
HAVING COUNT(*) <= 10
ORDER BY NUMBER_OF_VEHICLE DESC;

# Retrieve the electric vehicles located in areas with a 2020 Census Tract starting with "3".
SELECT Make,Model,2020_Census_Tract
FROM VEHICLE
WHERE 2020_Census_Tract LIKE "3%"
GROUP BY Make,Model;



