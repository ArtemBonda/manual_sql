CREATE TABLE aircrafts(
    aircraft_code char(3) NOT NULL ,
    model text NOT NULL ,
    range integer NOT NULL ,
    CHECK ( range > 0 ),
    PRIMARY KEY (aircraft_code)
);

CREATE TABLE seats (
    aircraft_code char(3) NOT NULL ,
    seat_no varchar(4) NOT NULL,
    fare_conditions varchar(10) NOT NULL
    CHECK ( fare_conditions IN('Economy', 'Comfort', 'Business') ),
    PRIMARY KEY (aircraft_code, seat_no),
    FOREIGN KEY (aircraft_code)
        REFERENCES aircrafts (aircraft_code)
        ON DELETE CASCADE
);