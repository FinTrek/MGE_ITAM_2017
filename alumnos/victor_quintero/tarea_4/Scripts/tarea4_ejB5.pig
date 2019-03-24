flights = load '$INPUT/flights.csv' using PigStorage(',') as (YEAR,MONTH,DAY,DAY_OF_WEEK,AIRLINE,FLIGHT_NUMBER,TAIL_NUMBER,ORIGIN_AIRPORT,DESTINATION_AIRPORT,SCHEDULED_DEPARTURE,DEPARTURE_TIME,DEPARTURE_DELAY,TAXI_OUT,WHEELS_OFF,SCHEDULED_TIME,ELAPSED_TIME,AIR_TIME,DISTANCE,WHEELS_ON,TAXI_IN,SCHEDULED_ARRIVAL,ARRIVAL_TIME,ARRIVAL_DELAY,DIVERTED,CANCELLED,CANCELLATION_REASON,AIR_SYSTEM_DELAY,SECURITY_DELAY,AIRLINE_DELAY,LATE_AIRCRAFT_DELAY,WEATHER_DELAY);
airports = load '$INPUT/airports.csv' using PigStorage(',') as (IATA_CODE,AIRPORT,CITY,STATE,COUNTRY,LATITUDE,LONGITUDE);
flights_airports = JOIN flights by ORIGIN_AIRPORT, airports by IATA_CODE; 
flights_cancelled = FILTER flights_airports by CANCELLED in ('1');
cancelled_group = GROUP flights_cancelled by AIRPORT;
cont = FOREACH cancelled_group GENERATE group as AIRPORT, COUNT($1) as cancellations;
cont_selected = FOREACH cont GENERATE AIRPORT, cancellations;
cont_order = ORDER cont_selected by cancellations DESC;
final = LIMIT cont_order 1;

store final into '$OUTPUT/output5/' using PigStorage(',', '-schema');
