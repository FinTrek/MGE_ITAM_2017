--- Apache Pig Script to load flights data into Pig
--- Author: Jorge III Altamirano Astorga
--- 
flights = load '/data/flights/flights.csv' using PigStorage(',') as (
  year:int, month:int, day:int, day_of_week:int, 
  airline:chararray, flight_number:int, tail_number:chararray,
  origin_airport:chararray, destination_airport:chararray,
  scheduled_departure:int, departure_time:int,
  departure_delay:long, taxi_out:int, wheels_off:int,
  scheduled_time:int, elapsed_time:int, air_time:int,
  distance:int, wheels_on:int, taxi_in:int, 
  scheduled_arrival:int, arrival_time:int, arrival_delay:int,
  diverted:int, cancelled:int, cancellation_reason:chararray,
  air_system_delay:chararray, security_delay:chararray,
  airline_delay:chararray, late_aircraft_delay:chararray,
  weather_delay:chararray);
airports = load '/data/flights/airports.csv' using PigStorage(',') as (
  iata_code:chararray, airport:chararray, city:chararray,
  state:chararray, country:chararray,
  latitude:double, longitude:double);
airlines = load '/data/flights/airlines.csv' using PigStorage(',') as (
  iata_code:chararray, airline:chararray);

flights_delay = FOREACH flights GENERATE flight_number AS flight_number, 
  airline AS airline, arrival_delay AS arrival_delay;
flights_order = ORDER flights_delay BY arrival_delay DESC; 
flights_limit = LIMIT flights_order 1;
flights_join = JOIN flights_limit by airline, airlines by iata_code;

--- airlines_airport_arr = JOIN flights by destination_airport, airports by iata_code;
--- airlines_filter = FILTER airlines_airport_arr BY airport matches 'Honolulu International Airport';

store flights_join into '/tarea_4/ejercicio_b.2' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'WRITE_OUTPUT_HEADER');
--- Example
--- 2015,1,1,4,B6,1030,N239JB,BQN,MCO,0307,0304,-3,25,0329,173,196,160,1129,0509,11,0500,0520,20,0,0,,20,0,0,0,0
