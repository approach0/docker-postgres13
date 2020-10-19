## Postgres v13 with pgweb

* username: postgres
* database: postgres
* password: postgres

### Usage
```
$ docker pull ga6840/postgres13
$ docker run -it -v `pwd`/tmp:/postgres/data -p 8080:80 -p 5432:5432 ga6840/postgres13
```
PostgreSQL is listening at port 5432, and pgweb is at port 80 in container, and above
command simply maps both to host, where pgweb can be accessed from `http://0.0.0.0:8080/`.

### PostgreSQL examples
* list database: `psql <<< '\list'`
* create table: `psql <<< "CREATE TABLE person (name text, age integer)"`
* insertion: `psql <<< "INSERT INTO person VALUES ('Tom', 19)"`
* query: `psql <<< 'SELECT * FROM person'`
* backup: `pg_basebackup` is used for a running PostgreSQL cluster.

### Links
* https://www.postgresql.org/docs/13/index.html
* https://github.com/sosedoff/pgweb
