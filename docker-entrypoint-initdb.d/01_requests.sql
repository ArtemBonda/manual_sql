INSERT INTO aircrafts (aircraft_code, model, range)
VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);

--SELECT * FROM aircrafts;

INSERT INTO aircrafts VALUES ('773', 'Boeing 777-300', 11100);

INSERT INTO aircrafts (aircraft_code, model, range)
VALUES ('763', 'Boeing 767-300', 7900),
       ('733', 'Boeing 737-300', 4200),
       ( '320', 'Airbus A320-200', 5700 ),
       ( '321', 'Airbus A321-200', 5600 ),
       ( '319', 'Airbus A319-100', 6700 ),
       ( 'CN1', 'Cessna 208 Caravan', 1200 ),
       ( 'CR2', 'Bombardier CRJ-200', 2700 );

SELECT model, aircraft_code, range
    FROM aircrafts
    ORDER BY model;

SELECT aircraft_code, model, range
    FROM aircrafts
    WHERE range >=4000 and range <= 11000;

UPDATE aircrafts
    SET range = 3500
    WHERE aircraft_code = 'SU9';
-- Проверка изменений
SELECT * FROM aircrafts WHERE aircraft_code = 'SU9';

--! Будет ошибка, нарушение ограничения внешнего ключа
--INSERT into seats VALUES ('123', '2A', 'Business');

INSERT INTO seats (aircraft_code, seat_no, fare_conditions)
    VALUES ('SU9', '1A', 'Business'),
           ('SU9', '1B', 'Business'),
           ('SU9', '10A', 'Comfort'),
           ('SU9', '10B', 'Comfort'),
           ('SU9', '10C', 'Comfort'),
           ('SU9', '20A', 'Economy'),
           ('SU9', '20F', 'Economy'),
           ('773', '1A', 'Business'),
           ('773', '1B', 'Business'),
           ('773', '10A', 'Comfort'),
           ('773', '10B', 'Comfort'),
           ('773', '10C', 'Comfort'),
           ('773', '20A', 'Economy'),
           ('773', '20F', 'Economy'),
           ('763', '1A', 'Business'),
           ('763', '1B', 'Business'),
           ('763', '10A', 'Comfort'),
           ('763', '10B', 'Comfort'),
           ('763', '10C', 'Comfort'),
           ('763', '20A', 'Economy'),
           ('763', '20F', 'Economy'),
           ('733', '1A', 'Business'),
           ('733', '1B', 'Business'),
           ('733', '10A', 'Comfort'),
           ('733', '10B', 'Comfort'),
           ('733', '10C', 'Comfort'),
           ('733', '20A', 'Economy'),
           ('733', '20F', 'Economy'),
           ('320', '1A', 'Business'),
           ('320', '1B', 'Business'),
           ('320', '10A', 'Comfort'),
           ('320', '10B', 'Comfort'),
           ('320', '10C', 'Comfort'),
           ('320', '20A', 'Economy'),
           ('320', '20F', 'Economy'),
           ('321', '1A', 'Business'),
           ('321', '1B', 'Business'),
           ('321', '10A', 'Comfort'),
           ('321', '10B', 'Comfort'),
           ('321', '10C', 'Comfort'),
           ('321', '20A', 'Economy'),
           ('321', '20F', 'Economy'),
           ('319', '1A', 'Business'),
           ('319', '1B', 'Business'),
           ('319', '10A', 'Comfort'),
           ('319', '10B', 'Comfort'),
           ('319', '10C', 'Comfort'),
           ('319', '20A', 'Economy'),
           ('319', '20F', 'Economy'),
           ('CR2', '1A', 'Business'),
           ('CR2', '1B', 'Business'),
           ('CR2', '2A', 'Business'),
           ('CR2', '2B', 'Business'),
           ('CR2', '3A', 'Business'),
           ('CR2', '3B', 'Business'),
           ('CR2', '4A', 'Business');

--SELECT aircraft_code, count(*) FROM seats GROUP BY aircraft_code;

--SELECT aircraft_code, count( * ) FROM seats GROUP BY aircraft_code ORDER BY count;

--SELECT aircraft_code, fare_conditions, count(*) FROM seats
--    GROUP BY aircraft_code, fare_conditions
--     ORDER BY aircraft_code, fare_conditions;

-- SELECT * FROM aircrafts ORDER BY range DESC ;

-- UPDATE aircrafts
--     SET range = range / 2
--     WHERE aircraft_code = 'SU9';


--  CHAPTER 4 --
-- CREATE TABLE databases (
--   is_open_source boolean ,
--   dbms_name text
-- );
-- insert  into databases
-- values (True, 'Postgres'),
--        (0::boolean, 'Oracle'),
--        (1::boolean, 'MySql'),
--        (false, 'MS SQL');
--
-- SELECT * from databases WHERE is_open_source = false;

-- Массивы
CREATE TABLE pilots (
  pilot_name text,
  shedule integer[]
);

INSERT INTO pilots
   VALUES ('Ivan', '{1, 3, 5, 6, 7}'),
          ('Petr', '{1, 2, 5, 7}'),
          ('Pavel', '{2, 5 }'),
          ('Boris', '{3, 5, 6}');

SELECT * FROM pilots;

UPDATE pilots
SET shedule = shedule || 7
WHERE pilot_name = 'Boris';

UPDATE pilots
SET shedule = array_append(shedule, 6)
WHERE pilot_name = 'Pavel';

UPDATE pilots
SET shedule = array_prepend(1, shedule)
WHERE pilot_name = 'Pavel';

UPDATE pilots
SET shedule = array_remove(shedule, 5)
WHERE pilot_name = 'Ivan';

UPDATE pilots
SET shedule[1] =2, shedule[2]=3
WHERE pilot_name = 'Petr';

UPDATE pilots
SET shedule[1:2] = ARRAY[2,3]
where pilot_name = 'Petr';

SELECT * FROM pilots
    WHERE array_position(shedule, 3) IS NOT NULL ;

SELECT * FROM pilots
    WHERE shedule @> '{1, 7}'::integer[];

SELECT * FROM pilots
WHERE shedule && ARRAY[2, 5];

SELECT * FROM pilots
WHERE NOT (shedule && ARRAY[2,5]);

SELECT pilot_name, unnest(shedule) AS days_of_week
    FROM pilots
    ORDER BY  days_of_week;

-- type JSON --

CREATE TABLE pilot_hobbies(
  pilot_name text,
  hobbies jsonb
);

INSERT INTO pilot_hobbies
    VALUES ('Ivan',
            '{"sports":["футбол","плавиние"],
                "home_lib": true, "trips":3
}'::jsonb),
        ('Petr',
         '{"sports":["теннис", "плавание"],
         "home_lin":true, "trips":2
                  }'::jsonb),
        ('Pavel',
         '{"sports":["плавание"],
           "home_lib": false, "trips": 4}'::jsonb),
        ('Boris',
         '{"sports":["футбол", "плавание", "теннис"],
            "home_lib":true, "trips":0
        }'::jsonb);

SELECT * From pilot_hobbies
    where hobbies @> '{"home_lib":true}'::jsonb;
SELECT pilot_name, hobbies->'sports' AS sport
    FROM pilot_hobbies
    WHERE hobbies->'sports' @> '["футбол"]'::jsonb;

-- Поиск в JSON значение true по кокретному ключу
SELECT pilot_name, hobbies->'home_lib'
    from pilot_hobbies
    WHERE hobbies->'home_lib' @> 'true'::jsonb;

SELECT count(*)
    FROM pilot_hobbies
    WHERE hobbies ? 'sports';

-- Обновить представление JSON
UPDATE pilot_hobbies
    SET hobbies=hobbies || '{"sports":["хоккей"]}'
    WHERE pilot_name='Boris';

UPDATE pilot_hobbies
    SET hobbies=hobbies || '{"home_lib":false}'
    WHERE pilot_name='Boris';
-- А как удалить неправильное вставленное поле у Бориса?^
update pilot_hobbies
set hobbies = jsonb_delete_path(hobbies, '{"home_lub"}')
where pilot_name='Boris';

UPDATE pilot_hobbies
    SET hobbies=jsonb_set(hobbies, '{sports, 1}', '"футбол"')
    WHERE pilot_name='Boris';

SELECT * From pilot_hobbies
    WHERE pilot_name='Boris';

COMMENT ON COLUMN airports.city IS 'Город в котором аэропорт';

--ALTER TABLE aircrafts DROP COLUMN speed;
-- ALTER TABLE aircrafts ADD COLUMN speed integer NOT NULL CHECK( speed >= 300 );
ALTER TABLE aircrafts ADD COLUMN speed integer;

UPDATE aircrafts SET speed = 807 WHERE aircraft_code = '733';
UPDATE aircrafts SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts SET speed = 905 WHERE aircraft_code = '773';
UPDATE aircrafts SET speed = 840
    WHERE aircraft_code IN ( '319', '320', '321' );
UPDATE aircrafts SET speed = 786 WHERE aircraft_code = 'CR2';
UPDATE aircrafts SET speed = 341 WHERE aircraft_code = 'CN1';
UPDATE aircrafts SET speed = 830 WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts;
Alter TABLE aircrafts ALTER COLUMN speed SET NOT NULL ;
ALTER TABLE aircrafts ADD CHECK ( speed >= 300 );

ALTER TABLE airports
    ALTER COLUMN longitude SET DATA TYPE numeric(5, 2),
    ALTER COLUMN latitude SET DATA TYPE numeric(5, 2);

INSERT INTO fare_conditions
    VALUES (1, 'Economy'),
           (2, 'Business'),
           (3, 'Comfort');

ALTER TABLE seats
    DROP CONSTRAINT seats_fare_conditions_check,
    ALTER COLUMN fare_conditions SET DATA TYPE integer
        USING ( CASE WHEN fare_conditions = 'Economy' THEN 1
                     WHEN fare_conditions = 'Business' THEN 2
                     ELSE 3 END
        );

ALTER TABLE seats
    ADD FOREIGN KEY (fare_conditions)
        REFERENCES fare_conditions (fare_conditions_code);

ALTER TABLE  seats
    RENAME COLUMN fare_conditions TO fare_conditions_code;

ALTER TABLE seats
    RENAME CONSTRAINT seats_fare_conditions_fkey
        TO seats_fare_conditions_code_fkey;

ALTER TABLE fare_conditions ADD UNIQUE ( fare_conditions_name );

