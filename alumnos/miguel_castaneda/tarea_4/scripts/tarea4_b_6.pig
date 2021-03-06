flights = LOAD 's3://metodosgranescala/flights/flights.csv' using PigStorage(',') as (year:int, month:int, day:int, day_of_week:int, airline:chararray, flight_number:int, tail_number:chararray, origin_airport:chararray, destination_airport:chararray, scheduled_departure:chararray, departure_time:chararray, departure_delay:int, taxi_out:int, wheels_off:chararray, scheduled_time:chararray, elapsed_time:int, air_time:int, distance:int, wheels_on:chararray, taxi_in:int, scheduled_arrival:chararray, arrival_time:chararray, arrival_delay:int, diverted:chararray, cancelled:chararray, cancellation_reason:chararray, air_system_delay:chararray, security_delay:chararray, airline_delay:chararray, late_aircraft_delay:chararray, weather_delay:chararray);
airports = LOAD 's3://metodosgranescala/flights/airports.csv' using PigStorage(',') as (iata_code:chararray, airport:chararray, city:chararray, state:chararray, country:chararray, latitude:float, longitude:float);
flights_airports = JOIN flights BY destination_airport , airports BY iata_code;
flights_number_g = GROUP flights_airports by flight_number;
dest_unicos = FOREACH flights_number_g { dest = FOREACH flights_airports GENERATE destination_airport; dest_unico = DISTINCT dest; GENERATE flatten(group) as flight_number, COUNT(dest_unico) as dest_unico_air; };
dest_unico_ord = ORDER dest_unicos BY dest_unico_air DESC;
dest_unico_1 = LIMIT dest_unico_ord 1;
tmp_flights = DISTINCT flights;
vuelo_div = JOIN dest_unico_1 BY flight_number, tmp_flights BY flight_number;
respuesta_6 = join vuelo_div by destination_airport LEFT OUTER, airports by iata_code;
STORE respuesta_6 INTO 's3://metodosgranescala/output/flights/6' USING PigStorage(',');
