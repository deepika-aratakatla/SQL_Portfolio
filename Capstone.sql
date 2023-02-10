---------------------------------------------------------------------------------------------------------
                           Fecthing the Data from Airline DB database via PostgreSQl
---------------------------------------------------------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.Questions: Find list of airport codes in Europe/Moscow timezone
 Expected Output:  Airport_code 

Query: 
select distinct airport_code from bookings.airports_data where timezone = 'Europe/Moscow' 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.	Write a query to get the count of seats in various fare condition for every aircraft code?
 Expected Outputs: Aircraft_code, fare_conditions ,seat count
Query : 
select distinct(aircraft_code),fare_conditions, count(seat_no) 
from bookings.seats group by 1,2 order by 3

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3.	How many aircrafts codes have at least one Business class seats?
 Expected Output : Count of aircraft codes

Query : 
select count(aircraft_code) from 
(select distinct(aircraft_code) from bookings.seats where fare_conditions='Business') as seats

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

4.	Find out the name of the airport having maximum number of departure flight
 Expected Output : Airport_name 

Query : 
select airport_name::json->> 'en' as airport_name
from (select departure_airport,count(departure_airport), 
a.airport_name from bookings.flights f 
inner join bookings.airports_data a on f.departure_airport=a.airport_code 
group by 1,3 order by 2 desc) as airport_name
limit 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
5.	Find out the name of the airport having least number of scheduled departure flights
 Expected Output : Airport_name 

Query : 
select airport_name::json->> 'en' as airport_name 
from (select departure_airport,count(departure_airport), a.airport_name 
	  from bookings.flights f inner join bookings.airports_data a 
	  on f.departure_airport=a.airport_code group by 1,3 order by 2 asc)
	  as poo limit 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.	How many flights from ‘DME’ airport don’t have actual departure?
 Expected Output : Flight Count 

Query: 
select count(distinct flight_no) as flight_count
from bookings.flights f
where departure_airport = 'DME' AND actual_departure IS NULL

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.	Identify flight ids having range between 3000 to 6000
 Expected Output : Flight_Number , aircraft_code, ranges 

Query :
select distinct(f.flight_no) , f.aircraft_code, a.range 
from bookings.flights f inner join bookings.aircrafts_data a 
on f.aircraft_code = a.aircraft_code
where a.range between 3000 and 6000 order by 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

8.	Write a query to get the count of flights flying between URS and KUF?
Expected Output : Flight_count

Query :
select count(distinct flight_no) from bookings.flights
where (departure_airport='URS' and arrival_airport='KUF') or (departure_airport='KUF' and arrival_airport='URS')

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

9.	Write a query to get the count of flights flying from either from NOZ or KRR?
 Expected Output : Flight count 

Answer:
SELECT COUNT(distinct departure_airport) AS Flight_count FROM bookings.FLIGHTS
WHERE departure_airport IN ('NOZ','KRR')

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

10.	Write a query to get the count of flights flying from KZN,DME,NBC,NJC,GDX,SGC,VKO,ROV
Expected Output : Departure airport ,count of flights flying from these   airports.

Query :
SELECT distinct(departure_airport), COUNT(*) as flight_count 
FROM bookings.flights WHERE departure_airport IN('KZN','DME','NBC','NJC','GDX','SGC','VKO','ROV') 
GROUP BY 1 ORDER BY 1 ASC

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

11.	Write a query to extract flight details having range between 3000 and 6000 and flying from DME
Expected Output :Flight_no,aircraft_code,range,departure_airport

Query :
select distinct(f.Flight_no), a.aircraft_code, a.range, f.departure_airport from bookings.Flights f
inner join bookings.aircrafts_data a on f.aircraft_code = a.aircraft_code
where f.departure_airport = 'DME' and a.range between 3000 and 6000
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

12.	Find the list of flight ids which are using aircrafts from “Airbus” company and got cancelled or delayed
 Expected Output : Flight_id,aircraft_model


Query :
select flight_id,model from (
select flight_id , model ,status
from bookings.flights f inner join bookings.aircrafts_data a 
on f.aircraft_code = a.aircraft_code
where model::json->> 'en' like '%Airbus%' and 
status in ('Cancelled','Delayed') ) as model

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

13.	Find the list of flight ids which are using aircrafts from “Boeing” company and got cancelled or delayed
Expected Output : Flight_id,aircraft_model

Query :
select flight_id,model  as aircraft_model from (
select flight_id, model,f.status 
from bookings.flights f inner join bookings.aircrafts_data a
on f.aircraft_code = a.aircraft_code
WHERE model::json->> 'en' like '%Boeing%'and (f.status = 'Cancelled' or f.status = 'Delayed')
order by model ) as model

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

14.	Which airport(name) has most cancelled flights (arriving)?
Expected Output : Airport_name 

Query :
WITH cancelled_details as (SELECT airport_name::json->> 'en' 
						   as airport_name, count(*) as cancelled_flight 
						   FROM bookings.flights f JOIN bookings.airports_data a ON f.arrival_airport=a.airport_code 
						   WHERE status='Cancelled' GROUP BY 1) 
						   SELECT airport_name 
						   FROM cancelled_details 
						   WHERE cancelled_flight=(SELECT MAX(cancelled_flight) FROM cancelled_details)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

15.	Identify flight ids which are using “Airbus aircrafts”
Expected Output : Flight_id,aircraft_model

Query :
select flight_id , model as aircraft_model
from bookings.flights f inner join bookings.aircrafts_data a 
on f.aircraft_code = a.aircraft_code
where  model::json->> 'en' like '%Airbus%'

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

16.	Identify date-wise last flight id flying from every airport?
Expected Output: Flight_id,flight_number,schedule_departure,departure_airport

Query :
select flight_id, flight_no, scheduled_departure, scheduled_arrival,departure_airport from 
(select *,Rank()over(partition by departure_airport order by scheduled_departure desc ) 
from bookings.flights ) as time where rank = 1 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

17.	Identify list of customers who will get the refund due to cancellation of the flights and how much amount they will get?
Expected Output : Passenger_name,total_refund

Query :
select passenger_name, max(amount) as total_refund
from bookings.flights f inner join bookings.TICKET_FLIGHTS tf
on  f.flight_id = tf.flight_id
inner join bookings.TICKETS t 
on tf.ticket_no = t.ticket_no
where status = 'Cancelled'
group  by 1 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

18.	Identify date wise first cancelled flight id flying for every airport?
Expected Output : Flight_id,flight_number,schedule_departure,departure_airport

Query : select flight_id, flight_no, scheduled_departure, scheduled_arrival,departure_airport 
from (select *,Rank()over(partition by departure_airport order by scheduled_departure ) 
from bookings.flights where status='Cancelled') as time where rank = 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

19.	Identify list of Airbus flight ids which got cancelled.
Expected Output : Flight_id

Query : 
Select flight_id from (
select flight_id , model ,status
from bookings.flights f inner join bookings.aircrafts_data a 
on f.aircraft_code = a.aircraft_code
where model::json->> 'en' like '%Airbus%' and 
status = 'Cancelled' ) as time 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

20.Identify list of flight ids having highest range. 
Expected Output : Flight_no, range

Query :
with airline as (select distinct f.Flight_no, a.range as base
from aircrafts a inner join flights f 
on a.aircraft_code = f.aircraft_code
order by 2 desc)
select Flight_no,base from airline where base=(SELECT MAX(base) FROM airline)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~