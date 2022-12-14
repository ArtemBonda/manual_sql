<h1 align="center">PostgreSQL</h1>


Изучение PostgreSQL по книге <a href="https://postgrespro.ru/education/books/sqlprimer">Е.П. Моргунова "PostgreSQL. Основы языка SQL"</a>
#### Таблицы
Данные взяты <a href="https://postgrespro.ru/education/demodb">с сайта</a>
- demo-small.sql  — данные по полетам за один месяц (размер БД примерно 300 МБ),
- demo-medium.sql — данные по полетам за три месяца (размер БД примерно 700 МБ)

## Миграция таблиц
 В директории `docker-entrypoint-initdb.d` - находятся файлы формата sql для миграции данных во время запуска контейнера
 
### Запуск 
 ```
 docker-compose up -d
 ```
    где `up` - поднять контейнер;
    флаг `-d` - работать в фоновом режиме
### Проверка
```text
docker-compose ps
```

В файле docker-compose.yml указаны переменные окружения для входа в СУБД
    - POSTGRES_USER=app
    - POSTGRES_PASSWORD=pass
    - POSTGRES_DB=db

### ! Необходимо было скопировть файл demo-small.sql в запущенный контейнер docker и сделать миграцию данных
1. В консоле IDE:

*  узнать ID контейнера
    ```
    docker container list
    ```

*  скопировать файл в контейнер
    ```
    docker cp demo-small/demo-small.sql [id_container]:demo-small.sql
    ```
   `[id_container]` - вставить номер id контейнера

2. Перейти в консоль докер
* Миграция данных
    ```
    psql -f demo-small.sql -U app -d db
    ```
3. Подключиться к БД sql
```
psql -U app -d db
```
или к мигрированной
```
psql -U app -d demo
```
где:

  `-U` - (`--username=app`) - флаг указывающий имя пользователя

  `-d` - (`--dbname=db`) - флаг указывающий имя базы данных
4. Также можно подключится к БД с миграционными данными
- IDE  во вкладке database ввести:
  * password: pass
  * db: demo
  * user : app

### Этапы обучения
Бывают два способа обучения
1. Использвание базы данных в которой уже содержаться все необходимые таблицы и другие объекты базы данных,
подготовленные заранее. При этом некоторый набор необходимых данных уже введен ви таблицы, поэтому можно
переходить к выполнению запросов к этим таблицам.  Этот способ будет полезен при изучении более сложных,
продвинутых возможностей языка SQL, которые сложно понять без использования больших массивов данных.

2. Выполняя запросы к базе данных и заполняя ее самостоятельно, будет легче оценивать правильность полученного
результата выполнения запроса, поэтому можно обосновано предположить, какие результаты ожидается увидеть на экране.
Этот способ будет полезен на первоначальном обучении, знакомству с синтаксисом и возможностями языка SQL