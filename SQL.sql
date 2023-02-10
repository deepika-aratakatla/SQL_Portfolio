---------------------------------------------------------------------------------------------------------
                           Fecthing the Data from Airline DB database via PostgreSQl
---------------------------------------------------------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.	Represent the “book_date” column in “yyyy-mmm-dd” format using Bookings table 
Expected output: book_ref, book_date (in “yyyy-mmm-dd” format) , total amount 
Query: 	
select 
bookings.book_ref, 
to_char(bookings.book_date,'yyyy-mon-dd')book_date, 
bookings.total_amount 
from bookings.bookings

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.	Get the following columns in the exact same sequence.
Expected columns in the output: ticket_no, boarding_no, seat_number, passenger_id, passenger_name.

Query: 
select bp.ticket_no,
bp.boarding_no,
bp.seat_no,
t.passenger_id,
t.passenger_name 
from bookings.boarding_passes bp
inner join bookings.tickets t	
on t.ticket_no = bp.ticket_no

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3.	Write a query to find the seat number which is least allocated among all the seats?

Query:  
select 
seat_no,(count(seat_no)) 
from bookings.boarding_passes 
group by 1 
order by 2 
limit 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

4.	In the database, identify the month wise highest paying passenger name and passenger id
Expected output: Month_name(“mmm-yy” format), passenger_id, passenger_name and total amount

Query:  		
select 			
month_name,
passenger_id,
passenger_name,
total_amount 
from 
(select to_char(b.book_date,'MON-YY') as month_name,
t.passenger_id ,
t.passenger_name ,
b.total_Amount,
rank () over (partition by to_char(b.book_date,'MON-YY') order by b.total_Amount desc ) as spend_rank
from bookings.tickets t inner join  bookings.bookings b
on b.book_ref = t.book_ref ) as poo
where spend_rank = 1
order by 1 desc

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

5.	In the database, identify the month wise least paying passenger name and passenger id?
Expected output: Month_name(“mmm-yy” format), passenger_id, passenger_name and total amount

Query:  
select 			
month_name,
passenger_id,
passenger_name,
total_amount 
from 
(select to_char(b.book_date,'MON-YY') as month_name,
t.passenger_id ,
t.passenger_name ,
b.total_Amount,
rank () over (partition by to_char(b.book_date,'MON-YY') order by b.total_Amount asc ) as spend_rank
from bookings.tickets t inner join  bookings.bookings b
on b.book_ref = t.book_ref ) as poo 
where spend_rank = 1
order by month_name

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.	Identify the travel details of non stop journeys  or return journeys (having more than 1 flight).
Expected Output: Passenger_id, passenger_name, ticket_number and flight count

Query:  	
select t.passenger_id , 
t.passenger_name , 
tf.ticket_no , 
count(tf.flight_id) as flight_count
from bookings.tickets t inner join bookings.ticket_flights tf
on t.ticket_no = tf.ticket_no
group by passenger_id , passenger_name , tf.ticket_no
having count(tf.flight_id) > 1
order by flight_count desc

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.	How many tickets are there without boarding passes?
Expected Output: just one number is required

Query:  	
select count(t.ticket_no) 
from bookings.tickets t left join bookings.boarding_passes b 
on t.ticket_no = b.ticket_no 
group by boarding_no 
having boarding_no is null

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

8.	Identify details of the longest flight (using flights table)?
Expected Output: Flight number, departure airport, arrival airport, aircraft code and durations

Query:  	
select flight_no,
(select max(scheduled_arrival - scheduled_departure) as duration from bookings.flights) 
from bookings.flights 
group by flight_no 
order by duration asc

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

9.	Categorize flights using following logic (using flights table)  :
a.	Early morning flights: 2 AM to 6AM
b.	Morning flights: 6 AM to 11 AM
c.	Noon flights: 11 AM to 4 PM
d.	 Evening flights: 4 PM to 7 PM
e.	Night flights: 7 PM to 11 PM 
f.	Late Night flights: 11 PM to 2 AM
Expected output: flight_id, flight_number, scheduled_departure, scheduled_arrival and timings
 
Query: 	
select flight_id, flight_no, scheduled_departure, scheduled_arrival, 
case  
when to_char(scheduled_departure,'HH24:MI:SS') between '02:00:00' and '06:00:00' then 'Early_Morning_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '06:00:00' and '11:00:00' then 'Morning_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '11:00:00' and '16:00:00' then 'Noon_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '16:00:00' and '18:00:00' then 'Evening_flight' 
when to_char(scheduled_departure,'HH24:MI:SS') between '18:00:00' and '23:00:00' then 'Night_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '23:00:00' and '2:00:00' then 'Late_Night_flight'
end as "Timings"
from bookings.Flights

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

10.	Identify details of all the morning flights (morning means between 6AM to 11 AM, using flights table)?
Expected output: flight_id, flight_number, scheduled_departure, scheduled_arrival and timings

Query: 
Select flight_id, flight_no, scheduled_departure, scheduled_arrival,departure_airport,
case 
when to_char(scheduled_departure,'HH24:MI:SS') between '06:00:00' and '11:00:00' then 'Morning_flight'
end as "Timings"
from bookings.Flights 
where to_char(scheduled_departure,'HH24:MI:SS') between '06:00:00' and '11:00:00';

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

11.	Identify the earliest morning flight available from every airport.
Expected output: flight_id, flight_number, scheduled_departure, scheduled_arrival, departure airport and timings
Query:  
select  flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport,
case  
when to_char(scheduled_departure,'HH24:MI:SS') between '02:00:00' and '06:00:00' then 'Early_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '06:00:00' and '11:00:00' then 'Morning_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '11:00:00' and '16:00:00' then 'Noon_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '16:00:00' and '18:00:00' then 'Evening_flight' 
when to_char(scheduled_departure,'HH24:MI:SS') between '18:00:00' and '23:00:00' then 'Night_flight'
when to_char(scheduled_departure,'HH24:MI:SS') between '23:00:00' and '2:00:00' then 'Late_flight'
end as "Timings"
from
(select *,Rank()over(partition by departure_airport order by actual_departure) 
 from bookings.flights ) as time where to_char(scheduled_departure,'HH24:MI:SS') between '06:00:00' and '11:00:00' 
and 
rank = 1  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
