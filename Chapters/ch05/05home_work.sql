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
