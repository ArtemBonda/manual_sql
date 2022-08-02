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

CREATE TABLE airports (
  airport_code char(3) NOT NULL , -- Код аэропорта
  airport_name text NOT NULL ,    -- Название аэропорта
  city text not null ,            -- Город
  longitude float not null ,      -- Координаты аэропорта: долгота
  latitude float not null ,       -- Координаты аэропорта: широта
  timezone text NOT NULL ,        -- Часовой пояс аэропорта
  PRIMARY KEY (airport_code)
);

CREATE TABLE flights (
  flight_id SERIAL NOT NULL ,   -- Идентификатор рейса
  flight_no char(4) NOT NULL ,  -- Номер рейса
  scheduled_departure timestamptz NOT NULL , -- Время вылета по расписанию
  scheduled_arrival timestamptz NOT NULL ,   -- Время прилета по расписанию
  departure_airport char(3) NOT NULL , -- Аэропорт отправления
  arrival_airport char(3) NOT NULL ,   -- Аропорт прибытия
  status varchar(20) NOT NULL ,        -- Статус рейса
  aircraft_code char(4) NOT NULL ,     -- Код самолета
  actual_departure timestamptz, -- Фактическое время вылета
  actual_arrival timestamptz,   -- Фактическое время прилета
  CHECK ( scheduled_departure < scheduled_arrival ),
  CHECK ( actual_arrival IS NULL OR
          (actual_departure IS NOT NULL AND
           actual_arrival IS NOT NULL AND
           actual_arrival > actual_departure
           )
          ),
  CHECK ( status IN ('On Time', 'Delayed', 'Departed',
                   'Arrived', 'Scheduled', 'Cancelled' )
      ),
    PRIMARY KEY (flight_id),
    UNIQUE (flight_no, scheduled_departure),
    FOREIGN KEY (aircraft_code)
        REFERENCES aircrafts(aircraft_code),
    FOREIGN KEY (arrival_airport)
        REFERENCES airports(airport_code),
    FOREIGN KEY (departure_airport)
        REFERENCES airports(airport_code)
);