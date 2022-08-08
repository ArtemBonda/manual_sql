-- #1
-- Задача добавить атрибуты с Constraint в таблицу Студенты,
ALTER TABLE students
    ADD COLUMN who_adds_rows text DEFAULT current_user;

SELECT * FROM students;

CREATE TABLE students(
    record_book numeric(5) NOT NULL PRIMARY KEY ,
    name text NOT NULL ,
    doc_ser numeric(4),
    doc_num numeric(6),
    who_adds_row text DEFAULT current_user -- кто добавил эту строку
);

INSERT INTO students (record_book, name, doc_ser, doc_num)
    VALUES (12147, 'Bond Artem', 235, 456789),
            (23489, 'Mono Liz', 8932, 009992)
;

-- Добавить новый атрибут записывающий текущее время добавления строки
ALTER TABLE students
    ADD COLUMN created_at timestamp;
-- Наложить на него ограничения DEFAULT
ALTER TABLE students
    ALTER COLUMN created_at SET DEFAULT current_timestamp;

INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (45623, 'Python Golang', 4572, 42389),
       (56723, 'Choke Bin', 8932, 000192)
;

-- Удалить атрибут
ALTER TABLE students
    DROP COLUMN created_at;
-- Удалить таблицу
DROP TABLE students CASCADE ;
DROP TABLE progress CASCADE ;

-- #2
-- Если таблица students удалялась  и заново создавалась, связать заново с progress
ALTER TABLE progress
    ADD FOREIGN KEY (record_book)
        REFERENCES students(record_book)
        ON DELETE CASCADE
        ON UPDATE CASCADE ;

-- Task: добавить атрибут test_form (c 2 значениямя 'экзамен' 'зачет')
ALTER TABLE progress
    ADD COLUMN test_form varchar(10);

ALTER TABLE progress
    ADD CHECK (
        (test_form = 'экзамен'  AND mark IN (3, 4, 5))
        OR
        (test_form = 'зачет' AND mark IN (0, 1))
        );

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
    VALUES (12141, 'Math', '2020', 1, 4, 'экзамен');

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
    VALUES (12143, 'Math', '2020', 1, 3, 'экзамен');
-- Конфликт
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
    VALUES (12141, 'Philosophy', '2020', 1, 0, 'зачет');

-- Удалить ограничение mark
ALTER TABLE progress
    DROP CONSTRAINT progress_mark_check;

-- Добавить ограничения под новую задачу
ALTER TABLE progress
    ADD CHECK ( (mark = 0 AND mark = 1)
                OR
            (mark >= 3 AND mark <= 5 )
            );

ALTER TABLE progress
    ALTER COLUMN mark SET DEFAULT 5;

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12143, 'Philosophy', '2020', 1, 1, 'зачет');

SELECT * FROM progress;

-- #3  В таблице "progress" проверить атрибуты term и mark не является ли ограничение NOT NULL избыточным
-- Задача: модифицируйте таблицу, убрав ограничение NOT NULL
ALTER TABLE progress
    ALTER COLUMN term DROP NOT NULL,
    ALTER COLUMN mark DROP NOT NULL ;
-- добавить в нее строку с отсутствующим значением атрибута term (или mark).
INSERT INTO progress (record_book, subject, acad_year, term)
    VALUES (12143, 'Algorithms', '2021/2022', 1);
INSERT INTO progress (record_book, subject, acad_year, mark)
    VALUES (12143, 'Algorithms', '2021/2022', 5);
-- Провести анализ полученных данных
SELECT * FROM progress;

-- Востановить ограничение NOT NULL. почему не получаетс?
ALTER TABLE progress
    ALTER COLUMN mark SET NOT NULL ,
    ALTER COLUMN term SET NOT NULL ;

-- #4 В ограничении DEFAULT «случайно» допустим ошибку, написав DEFAULT 6? На каком этапе эта ошибка будет выявлена:
-- уже на этапе создания таблицы или только при вставке строки в нее, если в команде INSERT не указать значение для атрибута mark?

ALTER TABLE progress
    ALTER COLUMN mark SET DEFAULT 6;

INSERT INTO progress ( record_book, subject, acad_year, term )
VALUES ( 12143, 'Физика', '2016/2017',1 );
-- Вывод: На уровне создания таблицы ошибка не выявлена, только при вставке данных

-- #6 Модифицируйте определений таблиц students и progress
DROP TABLE students CASCADE ;
DROP TABLE progress CASCADE ;

CREATE TABLE students (
    record_book numeric( 5 ) NOT NULL UNIQUE,
    name text NOT NULL,
    doc_ser numeric( 4 ),
    doc_num numeric( 6 ),
    PRIMARY KEY ( doc_ser, doc_num )
);

CREATE TABLE progress (
    doc_ser numeric( 4 ),
    doc_num numeric( 6 ),
    subject text NOT NULL,
    acad_year text NOT NULL,
    term numeric( 1 ) NOT NULL CHECK ( term = 1 OR term = 2 ),
    mark numeric( 1 ) NOT NULL CHECK ( mark >= 3 AND mark <= 5 )
      DEFAULT 5,
    FOREIGN KEY ( doc_ser, doc_num )
      REFERENCES students ( doc_ser, doc_num )
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
-- Теперь и первичный, и внешний ключи — составные. Проверьте их действие
INSERT INTO students
    VALUES (12345, 'Artem', 457, 123123) ;
INSERT INTO students
    VALUES (32112, 'Eliza', 234, 23231);


