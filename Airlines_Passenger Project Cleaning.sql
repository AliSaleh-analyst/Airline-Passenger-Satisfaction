Use airlines_passenger_satisfaction;

Create Table train
(customer_no int,
id int,
Gender Varchar (10),
Customer_Type Varchar(100),
Age int,
Type_of_Travel Varchar(100),
Class Varchar(50),
Flight_Distance int,
Inflight_wifi_service int,
Departure_Arrival_time_convenient int,
Ease_of_Online_booking int,
Gate_location int,
Food_and_drink int,
Online_boarding int,
Seat_comfort int,
Inflight_entertainment int,
On_board_service int,
Leg_room_service int,
Baggage_handling int,
Checkin_service int,
Inflight_service int,
Cleanliness int,
Departure_Delay_in_Minutes int,
Arrival_Delay_in_Minutes int,
satisfaction Varchar(50)
);

Select * from train;

SHOW VARIABLES LIKE 'secure_file_priv';

Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/train.csv' Into Table train
Fields Terminated By ','
Ignore 1 LINES
( `customer_no`, `id`, `Gender`, `Customer_Type`, `Age`, `Type_of_Travel`, `Class`, 
 `Flight_Distance`, `Inflight_wifi_service`, `Departure_Arrival_time_convenient`, 
 `Ease_of_Online_booking`, `Gate_location`, `Food_and_drink`, `Online_boarding`, 
 `Seat_comfort`, `Inflight_entertainment`, `On_board_service`, `Leg_room_service`, 
 `Baggage_handling`, `Checkin_service`, `Inflight_service`, `Cleanliness`, 
 `Departure_Delay_in_Minutes`, @Arrival_Delay_in_Minutes, `satisfaction`)  
SET
 Arrival_Delay_in_Minutes = NULLIF(@Arrival_Delay_in_Minutes, '') ;
 
 
Select * from train;                            # All these steps for importing data quickly 

-- Cleaning Process

Create Table train_clean 
like airlines_passenger_satisfaction.train;

insert Into train_clean
select * 
from train;

select * 
from train_clean;

-- 1- Removing Duplicate 



With cte_duplicate As (
select *, 
row_number() over(partition by id) As dup_id
from train_clean)                                            # There is no duplicate to remove 
select * from cte_duplicate 
where dup_id > 1 ;
                                                              

-- 2- Standardize the data 
Select * 
from train_clean;

select distinct(gender) 
from train_clean ;

select distinct(Customer_Type)
from train_clean;

Select distinct(Type_of_Travel)
from train_clean;

select distinct(Class)
from train_clean;

select  distinct(satisfaction)
from train_clean;


SELECT 
    COUNT(DISTINCT Type_of_Travel) AS travel_types,
    COUNT(DISTINCT Class) AS class_types,
    COUNT(DISTINCT satisfaction) AS satisfaction_levels
FROM train_clean;

-- 3- Removing blank and null values

Select *
from train_clean
where  customer_no IS NULL OR 
    id IS NULL OR 
    gender IS NULL OR 
    Customer_Type IS NULL OR 
    age IS NULL OR 
    Type_of_Travel IS NULL OR 
    Class IS NULL OR 
    Inflight_wifi_service IS NULL OR
    Departure_Arrival_time_convenient IS NULL OR 
    Ease_of_Online_booking IS NULL OR 
    Gate_location IS NULL OR 
    Food_and_drink IS NULL OR
    Online_boarding IS NULL OR 
    Seat_comfort IS NULL OR 
    Inflight_entertainment IS NULL OR  
    On_board_service IS NULL OR 
    Leg_room_service IS NULL OR
    Baggage_handling IS NULL OR 
    Checkin_service IS NULL OR  
    Inflight_service IS NULL OR 
    Cleanliness IS NULL OR 
    Departure_Delay_in_Minutes IS NULL OR
    Arrival_Delay_in_Minutes IS NULL OR 
    satisfaction IS NULL;
 ;
 
 SELECT *
FROM train_clean
WHERE 
    customer_no = '' OR
    id = '' OR
    gender = '' OR
    Customer_Type = '' OR
    age = '' OR
    Type_of_Travel = '' OR
    Class = '' OR
    Inflight_wifi_service = '' OR
    Departure_Arrival_time_convenient = '' OR
    Ease_of_Online_booking = '' OR
    Gate_location = '' OR
    Food_and_drink = '' OR
    Online_boarding = '' OR
    Seat_comfort = '' OR
    Inflight_entertainment = '' OR
    On_board_service = '' OR
    Leg_room_service = '' OR
    Baggage_handling = '' OR
    Checkin_service = '' OR
    Inflight_service = '' OR
    Cleanliness = '' OR
    Departure_Delay_in_Minutes = '' OR
    Arrival_Delay_in_Minutes = '' OR
    satisfaction = '';
    
    
SELECT * 
FROM train_clean 
WHERE Arrival_Delay_in_Minutes IS NULL;      # It is random data with less than 0.3% of our database -> I will keep it to preserve data integrity


-- 4- Removing any columns and rows

Select customer_no, customer_no + 1
from train_clean;

Update train_clean
Set customer_no = customer_no + 1 ;

Select *
from train_clean;