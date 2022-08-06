-- Контрольный ВОПРОСЫ
--№1
CREATE table test_numeric(
  meansurment numeric(5,2),
  description text
);

INSERT INTO test_numeric VALUES (999.9999, 'какое то измерение');
INSERT INTO test_numeric VALUES (999.9009, 'еще одно измерение');
INSERT INTO test_numeric VALUES (999.1111, 'и еще измерение');
INSERT INTO test_numeric VALUES (998.9999, 'и еще одно');
SELECT * FROM test_numeric;
--№2
drop Table test_numeric;

CREATE table test_numeric(
    meansurment numeric,
    description text
);

INSERT INTO test_numeric
VALUES ( 1234567890.0987654321,
         'Точность 20 знаков, масштаб 10 знаков' );
INSERT INTO test_numeric
VALUES ( 1.5,
         'Точность 2 знака, масштаб 1 знак' );
INSERT INTO test_numeric
VALUES ( 0.12345678901234567890,
         'Точность 21 знак, масштаб 20 знаков' );
INSERT INTO test_numeric
VALUES ( 1234567890,
         'Точность 10 знаков, масштаб 0 знаков (целое число)' );

--#3
-- Тип numeric поддерживает специальное значение "NaN"  которое озночает "не число"(not a number)
-- Считается что NaN равен другому значению NaN, а также больше любого лругого нормального значения.
SELECT 'NaN'::numeric > 1000000;
SELECT 'NaN'::numeric = 'NaN'::numeric;

--#4 При работе с числами типов real и double precision нужно помнить что сравнение 2 чисел с плавающей
-- точкойна предмет равенства
SELECT '1e-308'::double precision > '4e-324'::double precision;
-- Это происходит потому что результаты находяться на границе допустимого диапозона чисел  типов real и
-- double precision.
SELECT ' 5e-324'::double precision;
SELECT '4e-324'::double precision;

-- #5  Типы данных real и double precision поддерживают специальные значения
-- Infinity (бесконечность) и -Infinity (отрицательная бесконечность). Для типа double
-- precision (можно использовать сокращенное написание Inf):
SELECT 'Inf':: double precision > 1e+308;
SELECT '-Inf'::double precision < 1e-308;

-- #6  real и double precision поддерживают специальное значение NaN, которое означает
-- «не число» (not a number) e математике существует -- такое понятие, как неопределенность.
-- В качестве одного из ее вариантов служит результат операции умножения нуля на бесконечность
SELECT 0.0 * '-inf'::double precision;
-- значение NaN считается равным другому значению NaN, а также что значение NaN считается
-- большим любого другого «нормального» значения, т. е. не-NaN.
SELECT 'nan'::real = 'nan'::real;
SELECT 'nan'::real > 'inf'::real;

-- #7 применения типа serial предложим таблицу, содержащую наименования улиц
Create TABLE test_serial(
    id SERIAL,
    street text
);
insert into test_serial VALUES (10, 'Loog');
insert into test_serial (street) VALUES ('Hrom');
insert into test_serial VALUES (12, 'West');
insert into test_serial (street) values ('Grom');

-- явное задание значения для столбца id не влияет на автоматическое генерирование значений этого столбца
SELECT * from test_serial;
drop table test_serial;

-- #8
CREATE TABLE test_serial(
    id SERIAL PRIMARY KEY ,
    street text
);
insert into test_serial (street) VALUES ('Hrom');
insert into test_serial VALUES (2, 'Loog');
-- Объясни почему следующая строка сначла выдаст ошибку, а во второй раз - нет.
insert into test_serial (street) values ('Grom');
insert into test_serial (street )VALUES ('Ost');
Delete From test_serial WHERE id=4;
INSERT INTO test_serial (street) VALUES ('Green');

SELECT * from test_serial;
drop table test_serial;

--№ 9
-- Какой календарь используется в PostgreSQL для работы с датами: юлианский
-- или григорианский?

-- №10 Каждый тип данных из группы «дата/время» имеет ограничение на минимальное и максимальное допустимое значение.
-- Найдите в документации в разделе 8.5 «Типы даты/времени» эти значения и подумайте, почему они таковы.
SELECT '12.34'::float8::numeric::double precision;

-- #10 Каждый тип данных из группы «дата/время» имеет ограничение на минимальное и максимальное допустимое значение. Найдите в документации в разделе
-- 8.5 «Типы даты/времени» эти значения и подумайте, почему они таковы.

-- #29.* В тексте главы мы создавали таблицу с помощью команды
CREATE TABLE databases ( is_open_source boolean, dbms_name text );

-- и заполняли ее данными.
INSERT INTO databases VALUES ( TRUE, 'PostgreSQL' );
INSERT INTO databases VALUES ( FALSE, 'Oracle' );
INSERT INTO databases VALUES ( TRUE, 'MySQL' );
INSERT INTO databases VALUES ( FALSE, 'MS SQL Server' );
-- являются ли все приведенные ниже команды равнозначными в смысле результатов, получаемых с их помощью?
SELECT * FROM databases WHERE NOT is_open_source;
SELECT * FROM databases WHERE is_open_source <> 'yes';
SELECT * FROM databases WHERE is_open_source <> 't';
SELECT * FROM databases WHERE is_open_source <> '1';
SELECT * FROM databases WHERE is_open_source <> 1;


SELECT * FROM databases;
DROP TABLE databases;

-- 30.* Обратимся к таблице, создаваемой с помощью команды
CREATE TABLE test_bool ( a boolean, b text );
-- какие из приведенных ниже команд содержат ошибку
INSERT INTO test_bool VALUES ( TRUE, 'yes' );
INSERT INTO test_bool VALUES ( yes, 'yes' );
INSERT INTO test_bool VALUES ( 'yes', true );
INSERT INTO test_bool VALUES ( 'yes', TRUE );
INSERT INTO test_bool VALUES ( '1', 'true' );
INSERT INTO test_bool VALUES ( 1, 'true' );
INSERT INTO test_bool VALUES ( 't', 'true' );
INSERT INTO test_bool VALUES ( 't', truth );
INSERT INTO test_bool VALUES ( true, true );
INSERT INTO test_bool VALUES ( 1::boolean, 'true' );
INSERT INTO test_bool VALUES ( 111::boolean, 'true' );

SELECT * From test_bool;
drop table test_bool;

-- 31* в таблице birthdays хранятся даты рождения
CREATE table birthdays (
  person text not null,
  birthday date not null
);
-- Ввести примеры
INSERT INTO birthdays values ('Artem', '1985-09-13');
INSERT INTO birthdays values ('Danila', '1991-04-06');
INSERT INTO birthdays values ('Tima', '2016-08-29');
INSERT INTO birthdays values ('Mama', '1964-08-02');
INSERT INTO birthdays values ('Papa', '1964-04-28');


-- Кто родился в определенном месяце (extraact() -> имеет место неявное приведение типовб т.к. ее вторым параметром должно
-- быть значение типа timestamp)
SELECT * FROM birthdays
    WHERE extract('mon' from birthday) = 8;
-- Проверить кто достиг определенного возвраста пример - 40 лет
SELECT person, birthday+'40 years'::interval
    from birthdays
    Where birthday + '40 years'::interval<current_timestamp;
-- OR
SELECT person, birthday+'40 years'::interval
from birthdays
Where birthday + '40 years'::interval<current_date;

-- Определить точный возвраст
SELECT *, (current_date::timestamp - birthday::timestamp)::interval AS days
FROM birthdays ORDER BY days DESC;

-- 33*
-- Добавить атрибут meal text[] в таблицу pilots
ALTER TABLE pilots
    ADD COLUMN  meal text[];

-- Заполнить атрибут meal значениями
UPDATE pilots SET meal = '{"сосиска", "макароны", "кофе"}'::text[] WHERE pilot_name = 'Ivan';
UPDATE pilots SET meal = '{"котлета","каша","кофе"}'::text[] WHERE pilot_name = 'Petr';
UPDATE pilots SET meal = '{"сосиска","каша","кофе"}'::text[] WHERE pilot_name = 'Pavel';
UPDATE pilots SET meal = '{"котлета","каша", "чай"}'::text[] WHERE pilot_name = 'Boris';
-- Список пилотов, предпочитающих на обед сосиски
SELECT pilot_name, meal FROM pilots WHERE meal[1] = 'сосиска';
-- Задание. Создайте новую версию таблицы и соответственно измените команду INSERT, чтобы в ней содержались литералы двумерных массивов.
ALTER TABLE pilots DROP COLUMN meal;
ALTER TABLE pilots ADD COLUMN meal text[][];

ALTER TABLE pilots ALTER COLUMN meal SET DATA TYPE text[][];

UPDATE pilots SET meal = '{{"сосиска","макроны","кофе"},
                           {"котлета", "каша", "кофе" },
                           {"сосиска", "каша", "кофе" },
                           {"котлета", "каша", "чай" } }'::text[][] where pilot_name = 'Ivan';

UPDATE pilots SET meal = '{{"сосиска","макроны","кофе"},
                           {"котлета", "каша", "кофе" },
                           {"сосиска", "каша", "кофе" },
                           {"котлета", "каша", "чай" } }'::text[][] where pilot_name = 'Pavel';

-- ряд выборок и обновлений строк в этой таблице
SELECT pilot_name, meal FROM pilots
    WHERE pilots.meal[1] = 'котлета';
SELECT pilot_name, meal FROM pilots WHERE pilots.meal[1][2] = 'макроны';