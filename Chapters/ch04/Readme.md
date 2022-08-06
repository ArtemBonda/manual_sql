### Типы данных в Postgres

## Числовые
* smallint
* integer
* bigint

* numeric(s, p)
* decimal(s,p)
** s - scale(масштаб)
** p -precision(точность)
*** 12.3456 => масштаб = 4 (3456), точность = 6(общее количество символов)

* Числа с плавающей точкой
* real
* double precision

## Символьные
* character(n)
* character varying(n)
* text

## Время

* Интервал
Его синтаксис
```
quantity unit [quantity unit ...] direction
```
- unit - единица измеерения
- quantity - количество таких единиц
В качестве единиц измерений я можно использовать следующие: microsecond, millisecond,
second, minute, hour, day, week, month, year, decade, century, millennium
- direction - Этот параметр может принимать значение "ago"(т.е. тому назад), либо быть пустым.
```
select '1 year 2 months ago'::interval;
```
или о использовать альтернативный формат, предлагаемый стандартом ISO 8601:
```
P [ years-months-days ] [ T hours:minutes:seconds ]

```
- P - Здесь строка должна начинаться с символа "P"
- T -  разделяет дату и время (все выражение пишется без пробелов)
```
SELECT 'P0001-02-03T04:05:06'::interval;
```
* интервал — это отрезок времени между двумя временными отметками, то ´
значение этого типа можно получить при вычитании одной временной отметки из ´
другой.
```
SELECT ('2016-09-16'::timestamp - '2016-09-01'::timestamp)::interval;
```
* date_trunc -Усечение временных меток с той или иной точностью
* Например, для получени текущей временной отметки с точностью до одного часа
```
SELECT ( date_trunc( 'hour', current_timestamp ) );
```
* extract() - извлечение отдельных полей
* Например, получение номера месяца
```
select extract('mon', '2001-10-21 12:34:23, 1234');
```

## Логические типы
* boolean
* В качестве состояния «true» могут служить следующие значения: TRUE, 't', 'true', 'y',
'yes', 'on', '1'.
* В качестве состояния «false» могут служить следующие значения: FALSE, 'f', 'false', 'n',
'no', 'off', '0'.

## Массивы
- могут быть многомерными и могут содержать значения любого из встроенных типов, а также типов данных, определенных пользователем.
Схема объявления строки с типом массива
```
CREATE TABLE pilots (
pilot_name text,
shedule integer[]
);
```
* Заполнение данными
```
INSERT INTO pilots
    VALUES ('Ivan', '{1, 3, 5, 6, 7}')
    ....
;
```
* Опнрация конкатинации
```
UPDATE pilots
SET schedule = schedule || 7
WHERE pilot_name = 'Boris';
```
* Добавление в конец списк
```
UPDATE pilots
SET schedule = array_append( schedule, 6 )
WHERE pilot_name = 'Pavel';
```
* Добавлени в начало списка
```
UPDATE pilots
SET schedule = array_prepend( 1, schedule )
WHERE pilot_name = 'Pavel';
```
* Удаление из массива
```
UPDATE pilots
SET schedule = array_remove( schedule, 5 )
WHERE pilot_name = 'Ivan';
```
* r изменим дни полетов, не изменяя их общего количества.
Воспользуемся индексами для работы на уровне отдельных элементов массива.
```
UPDATE pilots
SET shedule[1] =2, shedule[2]=3
WHERE pilot_name = 'Petr';
```
или  используя срез (slice) массива
```
UPDATE pilots
SET schedule[ 1:2 ] = ARRAY[ 2, 3 ]
WHERE pilot_name = 'Petr';
```
* Функция array_position() возвращает индекс первого вхождения элемента с указанным
значением в массив. Если же такого элемента нет, она возвратит NULL.
** список пилотов, которые летают каждую среду
```
SELECT * FROM pilots
WHERE array_position( schedule, 3 ) IS NOT NULL;
```
* Оператор @> означает проверку того факта, что в левом массиве содержатся все элементы правого массива.
Выберем пилотов, летающих по понедельникам и воскресеньям:
```
SELECT * FROM pilots
WHERE shedule @> '{1, 7}'::integer[];
```
или воспользоваться опвератором &&, который проиверяет наличие общих элементова у массива
```
SELECT * FROM pilots
    WHERE shedule && ARRAY[2, 5];
```

* : кто не летает ни во вторник, ни в пятницу? Для получения ответа добавим в предыдущую SQL-команду отрицание NOT:
```
SELECT * FROM pilots
    WHERE NOT (shedule && ARRAY[2,5]);
```
* функция unnest() - Развернет массив в виде столбца  таблицы.
```
SELECT pilot_name, unnest(shedule) AS days_of_week
FROM pilots
ORDER BY  days_of_week;
```

## типы JSON
Существует 2 типа: json и jsonb. Основное различие между ними заключается в быстродействии
* json - а сохранение значений происходит быстрее, потому что они записываются в том виде, в котором были введены.
Но при последующем использовании этих значений в качестве операндов или параметров функций будет каждый раз выполняться
их разбор, что замедляет работу.
* jsonb - разбор производится однократно, при записи значения в таблицу. Это несколько замедляет операции вставки строк,
в которых содержатся значения данного типа. Но все последующие обращения к сохраненным значениям выполняются быстрее,
т. к. выполнять их разбор уже не требуется.
* тип json сохраняет порядок следования ключей в объектах и повторяющиеся значения ключей, а тип jsonb этого не делает.
Рекомендуется в приложениях использовать тип jsonb, если только нет каких-то особых аргументов в пользу выбора типа json.
-- Создадим таблицу:
```
CREATE TABLE pilot_hobbies (
    pilot_name text,
    hobbies json
);
```
Добавим значения
```
INSERT INTO pilot_hobbies
    VALUES ( 'Ivan',
    '{ "sports": [ "футбол", "плавание" ],
    "home_lib": true, "trips": 3
    }'::jsonb
    ),
    ( 'Petr',
    '{ "sports": [ "теннис", "плавание" ],
    "home_lib": true, "trips": 2
    }'::jsonb
    ),
    ( 'Pavel',
    '{ "sports": [ "плавание" ],
    "home_lib": false, "trips": 4
    }'::jsonb
    ),
    ( 'Boris',
    '{ "sports": [ "футбол", "плавание", "теннис" ],
    "home_lib": true, "trips": 0
    }'::jsonb
    );

```
Поиск кто играет в футбол
```
SELECT * FROM pilot_hobbies
WHERE hobbies @> '{ "sports": [ "футбол" ] }'::jsonb;
```
или с операцией " -> " которая служит для обращения к конкретному ключую
```
SELECT pilot_name, hobbies->'sports' AS sport
    FROM pilot_hobbies
    WHERE hobbies->'sports' @> '["футбол"]'::jsonb;
```

Оператор " ? " проверка если такой ключ в JSON объекте

```
SELECT count(*)
    FROM pilot_hobbies
    WHERE hobbies ? 'sports';
```
Обновить значение в поле 
```
UPDATE pilot_hobbies
    SET hobbies=hobbies || '{"sports":["хоккей"]}'
    WHERE pilot_name='Boris';
```
Например можно вставить неправильное згачение или сделать опечатку в ключе, чтобы измеить или удалить этот ключ 
мого использовать jsonb_delete() или jsonb_delete_path()
```
update pilot_hobbies
set hobbies = jsonb_delete_path(hobbies, '{"home_lub"}')
where pilot_name='Boris';
```
добавить значение jsonb_set()
```
UPDATE pilot_hobbies
    SET hobbies=jsonb_set(hobbies, '{sports, 1}', '"футбол"')
    WHERE pilot_name='Boris';
```
