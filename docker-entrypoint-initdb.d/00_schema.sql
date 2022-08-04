-- Таблица самолеты
CREATE TABLE aircrafts(
    aircraft_code char(3) NOT NULL ,
    model text NOT NULL ,
    range integer NOT NULL ,
    CHECK ( range > 0 ),
    PRIMARY KEY (aircraft_code)
);

-- Таблица места
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

-- Таблица аэропорты
CREATE TABLE airports (
  airport_code char(3) NOT NULL , -- Код аэропорта
  airport_name text NOT NULL ,    -- Название аэропорта
  city text not null ,            -- Город
  longitude float not null ,      -- Координаты аэропорта: долгота
  latitude float not null ,       -- Координаты аэропорта: широта
  timezone text NOT NULL ,        -- Часовой пояс аэропорта
  PRIMARY KEY (airport_code)
);

-- Таблица перелеты
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

-- Таблица Бронирование
CREATE TABLE bookings(
  book_ref char(6) NOT NULL ,        -- Номер бронирования
  book_date timestamptz NOT NULL ,   -- Дата бронирования
  total_amount numeric(10, 3) NOT NULL , -- Полная стоимость бронирования
  primary key (book_ref)
);

-- Таблица Билеты
CREATE TABLE tickets(
    ticket_no char(13) NOT NULL , -- Номер билета
    book_ref char(6) NOT NULL ,   -- Номер бронирования
    passenger_id varchar(20) NOT NULL , -- Идентификатор пассажира
    passenger_name text NOT NULL ,  -- Имя пассажира
    contact_data jsonb,             -- Контактные данные пассажира
    PRIMARY KEY (ticket_no),
    FOREIGN KEY (book_ref)
        REFERENCES bookings (book_ref)
);

-- Таблица перелеты
CREATE TABLE ticket_flights (
  ticket_no char(13) NOT NULL , -- Номер билета
  flight_id integer NOT NULL ,  -- Идентификатор рейса
  fare_conditions varchar(10) NOT NULL , -- Класс обслуживания
  amount numeric(10,2) NOT NULL , -- Стоимость перелета
  CHECK ( amount >= 0 ),
  CHECK ( fare_conditions IN ('Economy', 'Comfort', 'Business') ),
  PRIMARY KEY (ticket_no, flight_id),
  FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id),
  FOREIGN KEY (ticket_no)
        REFERENCES tickets(ticket_no)
);

-- Посадочные талоны
CREATE TABLE boarding_pases(
    ticket_no char(13) NOT NULL ,  -- Номер билета
    flight_id integer NOT NULL ,   -- Идентификатор рейса
    boarding_no integer NOT NULL , -- Номер посадочног билета
    seat_no varchar(4) NOT NULL ,  -- Номер места
    PRIMARY KEY (ticket_no, flight_id),
    UNIQUE (flight_id,boarding_no),
    UNIQUE (flight_id,seat_no),
    FOREIGN KEY (ticket_no, flight_id)
        REFERENCES ticket_flights(ticket_no, flight_id)
);

-- Таблица классы обслуживания
CREATE TABLE fare_conditions(
    fare_conditions_code integer,
    fare_conditions_name varchar(10) NOT NULL,
    PRIMARY KEY (fare_conditions_code)
);