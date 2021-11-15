## Postgres v13 with pgweb

* username: postgres
* database: postgres
* password: postgres

### Usage
```
$ docker pull approach0/postgres13
$ docker run -it -v `pwd`/tmp:/postgres/data -p 8080:80 -p 5432:5432 approach0/postgres13
```
PostgreSQL is listening at port 5432, and pgweb is at port 80 in container, and above
command simply maps both to host, where pgweb can be accessed from `http://0.0.0.0:8080/`.

### PostgreSQL examples
* list database: `psql <<< '\list'`
* list table: `psql <<< '\dt'`
* create table: `psql <<< "CREATE TABLE person (name text, age integer)"`
* insertion: `psql <<< "INSERT INTO person VALUES ('Tom', 19)"`
* query: `psql <<< 'SELECT * FROM person'`
* backup: `pg_basebackup` is used for a running PostgreSQL cluster.

### Auto Backups
This image will automatically dump `postgres` database every day at 3:01 am, and keep at most last 7 days of dump files.
One can restore a database from dump file by executing similar command like below:
```sh
# ./entrypoint.sh clean_and_restore 2020-11-27.dump
```
(be aware that doing this will reset all data in the database named `postgres`)

Also, as a test for cron job, a newline of datetime at time being will be appended to `/postgres/data/cron-test.log` every minute, until a new backup is generated and that file will be reset.

### Links
* https://www.postgresql.org/docs/13/index.html
* https://github.com/sosedoff/pgweb
