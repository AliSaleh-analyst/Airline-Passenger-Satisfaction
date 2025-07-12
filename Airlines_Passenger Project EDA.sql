Select *
from train_clean;

Create table train_eda 
(`customer_no` int DEFAULT NULL,
  `id` int DEFAULT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `Customer_Type` varchar(100) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Type_of_Travel` varchar(100) DEFAULT NULL,
  `Class` varchar(50) DEFAULT NULL,
  `Flight_Distance` int DEFAULT NULL,
  `Inflight_wifi_service` int DEFAULT NULL,
  `Departure_Arrival_time_convenient` int DEFAULT NULL,
  `Ease_of_Online_booking` int DEFAULT NULL,
  `Gate_location` int DEFAULT NULL,
  `Food_and_drink` int DEFAULT NULL,
  `Online_boarding` int DEFAULT NULL,
  `Seat_comfort` int DEFAULT NULL,
  `Inflight_entertainment` int DEFAULT NULL,
  `On_board_service` int DEFAULT NULL,
  `Leg_room_service` int DEFAULT NULL,
  `Baggage_handling` int DEFAULT NULL,
  `Checkin_service` int DEFAULT NULL,
  `Inflight_service` int DEFAULT NULL,
  `Cleanliness` int DEFAULT NULL,
  `Departure_Delay_in_Minutes` int DEFAULT NULL,
  `Arrival_Delay_in_Minutes` int DEFAULT NULL,
  `satisfaction` varchar(50) DEFAULT NULL) ;
  
  Select *
  from train_eda;
  
  
  Insert into train_eda 
  Select *
  from train_clean;
  
  
  Select *
  from train_eda;
  
  
  Select Customer_Type, count(customer_type) customer_count,
  Round(count(customer_type) / (Select count(customer_type) from train_eda) * 100, 2) As 'percentage(%)'
  from train_eda
  Group by customer_type
 ;
 
 
 Select class, count(class) class_count,
 Round(count(class) / (Select count(class) from train_eda) * 100, 2) As 'class_percentage(%)'
 from train_eda
 Group by class ; 
 
 
  Select Customer_Type,class, count(customer_type) customer_count,
  Round(count(customer_type) / (Select count(customer_type) from train_eda) * 100, 2) As 'percentage(%)'
  from train_eda
  Group by customer_type, class
  Order by 1, 4 DESC ;
  
  select customer_type, satisfaction, count(Customer_Type)
  from train_eda
  Group by Customer_Type, satisfaction ; 
  
  
  Select Customer_Type ,count(customer_type), Arrival_Delay_in_Minutes
  from train_eda
  where Arrival_Delay_in_Minutes = 0 
  group by customer_type ;
  
  Select customer_type, Inflight_wifi_service, Departure_Arrival_time_convenient, 
  Ease_of_Online_booking, Gate_location, Food_and_drink, Online_boarding,
  Seat_comfort, Inflight_entertainment, On_board_service, Leg_room_service,
  Baggage_handling, Checkin_service, Inflight_service, Cleanliness, Departure_Delay_in_Minutes, 
  Arrival_Delay_in_Minutes, satisfaction
  from train_eda
  Where Customer_Type like 'disloyal%' And satisfaction like 'neutral%';
  
  select *
  from train_eda;
  
  
  -- Where all of the reviews on the service are from 5 points, I want to sum all of these together to get better overview of the data
  
  Select id, satisfaction,
  (Inflight_wifi_service+ Departure_Arrival_time_convenient+
  Ease_of_Online_booking+ Gate_location+ Food_and_drink+ Online_boarding+
  Seat_comfort+ Inflight_entertainment+ On_board_service+ Leg_room_service+
  Baggage_handling+ Checkin_service+ Inflight_service+ Cleanliness) As 'total_review( /80)'
  from train_eda 
  Order by 3 DESC ;
  
  Create temporary table temp_total_review (
  id int,
  satisfaction varchar(255),
  `total_review( /80)` int );
  
  insert into temp_total_review  select
  id,
  satisfaction,
  IFNULL(Inflight_wifi_service,0) + 
  IFNULL(Departure_Arrival_time_convenient,0) +
  IFNULL(Ease_of_Online_booking,0) + 
  IFNULL(Gate_location,0) +
  IFNULL(Food_and_drink,0) + 
  IFNULL(Online_boarding,0) +
  IFNULL(Seat_comfort,0) + 
  IFNULL(Inflight_entertainment,0) +
  IFNULL(On_board_service,0) + 
  IFNULL(Leg_room_service,0) +
  IFNULL(Baggage_handling,0) + 
  IFNULL(Checkin_service,0) +
  IFNULL(Inflight_service,0) + 
  IFNULL(Cleanliness,0) 
  from train_eda ;
  
  
  select id,satisfaction,`total_review( /80)`, 
  max(`total_review( /80)`) over() AS max_dissatisfied
  from temp_total_review
  where satisfaction like 'neutral%'
  order by 3 DESC; 
  
  
  Select 
 max(Case
	when satisfaction like 'neutral%' then `total_review( /80)` 
	End) As max_dissatisfied,
min(Case 
	when satisfaction like "satis%" then `total_review( /80)` 
    End) As min_satisfied
 from temp_total_review
 ;
 
 
 Select *
 from train_eda
 ;
 
 
 -- Demographic Analysis 
 -- 1- Travel class distribution (Economy/Business/First)
 
 Select *
 from train_eda;
 
 Select satisfaction, 
 class,
 count(*) As passenger_count,
 Round(count(*) * 100 / Sum(count(*)) over(partition by class),2) As percentage
 from train_eda 
 group by satisfaction ,class
 order by 2, 3 DESC;
 
 
 -- 2- Age group vs. satisfaction correlation  
 
SELECT 
    satisfaction,
    COUNT(CASE WHEN age < 20 THEN 1 ELSE NULL END) AS under_20,  
    COUNT(CASE WHEN age BETWEEN 20 AND 40 THEN 1 ELSE NULL END) AS age_20_40,
    COUNT(CASE WHEN age BETWEEN 40 AND 60 THEN 1 ELSE NULL END) AS age_40_60,
    COUNT(CASE WHEN age > 60 THEN 1 ELSE NULL END) AS over_60
FROM train_eda
GROUP BY satisfaction
ORDER BY satisfaction;

-- 	Flight Operations
-- 1-Average departure delay duration  

select Satisfaction,
Avg(departure_delay_in_minutes) 'departure_delay(min)'
from train_eda
where Departure_Delay_in_Minutes > 0 
group by 1 ;

Select satisfaction,
Count(case when Departure_Delay_in_Minutes > 0 then Departure_Delay_in_Minutes End) Delayed_Flights,
count(case when Departure_Delay_in_Minutes <= 0 then 1 Else null End) ON_Time_Flights
from train_eda
 Group by 1 ;



-- 2-Flight distance vs. satisfaction correlation  
  
  select satisfaction,
  Avg(flight_distance) Avg_distance ,
  Sum(case when Flight_Distance <= 500 then 1 Else 0 End) short_distance,
  Sum(case when Flight_Distance between 500 and 1500 then 1 else 0 End) medium_distance,
  Sum(case when Flight_Distance >= 1500 Then 1 Else 0 End) long_distance
  from train_eda
  group by 1;
  
  
  -- Service Quality
  -- 1- Seat comfort average rating  
  
  Select Satisfaction, Class,
  Avg(Seat_comfort) Avg_seat_score,
  Round(Std(seat_comfort), 2) AS Std_rate,
  Sum(case when Seat_comfort <= 2 Then 1 Else Null End) AS low_ratings
  from train_eda 
  Group by Satisfaction, Class
  Order by 3 DESC;
  
  
  
  -- 2- Inflight wifi satisfaction gap  
  
  select AVG(Inflight_wifi_service) As avg_wifi_ratings, Satisfaction, 
  Round(Sum(case when Flight_Distance < 500 then 1 else 0 End) * 100.0 / count(*), 2)  short_distance_percent,
  Round(Sum(case when Flight_Distance between 500 and 1500 then 1 else 0 End) * 100.0 / count(*), 2) mid_distance_percent,
  Round(Sum(case when Flight_Distance > 1500 then 1 else 0 End)*100.0 / count(*), 2) long_distance_percent
  from train_eda
  group by satisfaction ;
  
  Select avg(Inflight_wifi_service),satisfaction, Class
  from train_eda
  where Flight_Distance > 1500
  group by satisfaction, Class
  Order by 1 desc;
  
  
-- Satisfaction Drivers

-- 1-  Minimum comfort score for reliable satisfaction

Select Seat_comfort,
count(case when trim(satisfaction) like 'satisfied%' then 1 Else null End) * 100.0 / count(*) As percent_satisfied 
from train_eda
where Seat_comfort > 0 
group by Seat_comfort
order by Seat_comfort;

-- 2- Baggage handling as churn indicator  

Select Baggage_handling,
count(Case When Customer_Type = 'Loyal Customer' Then 1 Else Null End) *100.0 / Count(*) As Loyal_per,
count(Case When Customer_Type = 'disloyal Customer' Then 1 Else Null End) *100.0 / Count(*) AS Disloyal_per
from train_eda
group by Baggage_handling
Order by Baggage_handling;


-- Comparative Insights
-- 1-  Male vs. female rating differences 

Select Gender,
Avg (Inflight_wifi_service),
Avg (Departure_Arrival_time_convenient),
Avg (Ease_of_Online_booking),
Avg (Gate_location),
Avg (Food_and_drink),
Avg (Online_boarding),
Avg (Seat_comfort),
Avg (Inflight_entertainment),
Avg (On_board_service),
Avg (Leg_room_service),
Avg (Baggage_handling),
Avg (Checkin_service),
Avg (Inflight_service),
Avg (Cleanliness),
count(Case When satisfaction like 'satisfied%' Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent
From train_eda
Group by gender;

-- 2- Loyal vs Disloyal Customers 

Select Customer_Type,
Avg (Inflight_wifi_service),
Avg (Departure_Arrival_time_convenient),
Avg (Ease_of_Online_booking),
Avg (Gate_location),
Avg (Food_and_drink),
Avg (Online_boarding),
Avg (Seat_comfort),
Avg (Inflight_entertainment),
Avg (On_board_service),
Avg (Leg_room_service),
Avg (Baggage_handling),
Avg (Checkin_service),
Avg (Inflight_service),
Avg (Cleanliness),
count(Case When satisfaction like 'satisfied%' Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent
From train_eda
Group by Customer_Type;



-- Delay Impact

-- 1- Satisfaction drop per time delay

Select 
count(Case When satisfaction like 'satisfied%' and Arrival_Delay_in_Minutes between 0 and 10 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent10,
count(Case When satisfaction like 'satisfied%' and Arrival_Delay_in_Minutes between 10 and 20 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent20,
count(Case When satisfaction like 'satisfied%' and Arrival_Delay_in_Minutes between 20 and 30 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent30,
count(Case When satisfaction like 'satisfied%' and Arrival_Delay_in_Minutes between 30 and 60 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent60,
count(Case When satisfaction like 'satisfied%' and Arrival_Delay_in_Minutes >60 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent90
from train_eda;


Select 
count(Case When satisfaction like 'satisfied%' and Departure_Delay_in_Minutes between 0 and 10 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent10,
count(Case When satisfaction like 'satisfied%' and Departure_Delay_in_Minutes between 10 and 20 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent20,
count(Case When satisfaction like 'satisfied%' and Departure_Delay_in_Minutes between 20 and 30 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent30,
count(Case When satisfaction like 'satisfied%' and Departure_Delay_in_Minutes between 30 and 60 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent60,
count(Case When satisfaction like 'satisfied%' and Departure_Delay_in_Minutes >60 Then 1 Else Null End) * 100.0 / Count(*) As satisfied_percent90
from train_eda;


-- Satisfaction score clustering 

Select 
Avg(Case When satisfaction like 'satisfied%' Then Inflight_wifi_service Else Null End) -
Avg(Case When satisfaction != 'satisfied%' Then Inflight_wifi_service Else Null End) As Wifi_gap,

Avg(Case When satisfaction like 'satisfied%' Then Departure_Arrival_time_convenient Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Departure_Arrival_time_convenient Else Null End) As Depa_gap,

Avg(Case When satisfaction like 'satisfied%' Then Ease_of_Online_booking Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Ease_of_Online_booking Else Null End) As ease_gap,

Avg(Case When satisfaction like 'satisfied%' Then Gate_location Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Gate_location Else Null End) As gate_gap,

Avg(Case When satisfaction like 'satisfied%' Then Food_and_drink Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Food_and_drink Else Null End) As food_gap,

Avg(Case When satisfaction like 'satisfied%' Then Online_boarding Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Online_boarding Else Null End) As online_gap,

Avg(Case When satisfaction like 'satisfied%' Then Seat_comfort Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Seat_comfort Else Null End) As seat_gap,

Avg(Case When satisfaction like 'satisfied%' Then Inflight_entertainment Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Inflight_entertainment Else Null End) As entertainment_gap,

Avg(Case When satisfaction like 'satisfied%' Then On_board_service Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then On_board_service Else Null End) As onboard_gap,

Avg(Case When satisfaction like 'satisfied%' Then Leg_room_service Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Leg_room_service Else Null End) As leg_gap,

Avg(Case When satisfaction like 'satisfied%' Then Baggage_handling Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Baggage_handling Else Null End) As baggage_gap,

Avg(Case When satisfaction like 'satisfied%' Then Checkin_service Else Null End)-
Avg(Case When satisfaction !=  'satisfied%' Then Checkin_service Else Null End) As checkin_gap,

Avg(Case When satisfaction like 'satisfied%' Then Inflight_service Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Inflight_service Else Null End) As Inflight_gap,

Avg(Case When satisfaction like 'satisfied%' Then Cleanliness Else Null End)-
Avg(Case When satisfaction != 'satisfied%' Then Cleanliness Else Null End) As clean_gap
from train_eda;


Select
Case 
	When online_boarding < 2 Then 'Digital_pain'
    When seat_comfort < 2 Then 'Uncomfortable'
    When inflight_entertainment <2 Then 'Bored'
    Else 'Satisfied_Core'
    End AS Passengers_Segments,
    Count(*) As Passengers,
    Count(Case When satisfaction like 'satisfied%' Then 1 Else Null End)* 100.0 / Count(*) As satisfaction_rate
    from train_eda
    Group by 1;
    
Select count(*)
from train_eda
Where satisfaction Not like 'satisfied%';

Select count(*) AS Unhappy_Customer from
( Select 
	Case 
		When online_boarding < 2 Then 'Digital_pain'
		When seat_comfort < 2 Then 'Uncomfortable'
		When inflight_entertainment <2 Then 'Bored'
		Else Null
		End As cluster
        from train_eda
        Where satisfaction Not like 'satisfied%')  AS cluster_data
        Where Cluster In ('Digital_pain','Uncomfortable', 'Bored') ;
        
        


Select
Case 
	When online_boarding < 2 Then 'Digital_pain'
    When seat_comfort < 2 Then 'Uncomfortable'
    When inflight_entertainment <2 Then 'Bored'
    When on_board_service < 2 Then 'Poor Service'
    When leg_room_service < 2 Then 'Tight Room Space'
    When Cleanliness < 2 Then 'Dirty'
    Else 'Satisfied_Core'
    End AS Passengers_Segments,
    Count(*) As Passengers,
    Count(Case When satisfaction like 'satisfied%' Then 1 Else Null End)* 100.0 / Count(*) As satisfaction_rate
    from train_eda
    Group by 1;
        

Select count(*) AS Unhappy_Customer from
( Select 
	Case 
		When online_boarding < 2 Then 'Digital_pain'
		When seat_comfort < 2 Then 'Uncomfortable'
		When inflight_entertainment <2 Then 'Bored'
		When on_board_service < 2 Then 'Poor Service'
		When leg_room_service < 2 Then 'Tight Room Space'
		When Cleanliness < 2 Then 'Dirty'
		Else Null
		End As cluster
        from train_eda
        Where satisfaction Not like 'satisfied%')  AS cluster_data
        Where Cluster In ('Digital_pain','Uncomfortable', 'Bored', 'Poor Service', 'Tight Room Space', 'Dirty') ;




 