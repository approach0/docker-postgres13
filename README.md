## Postgres v13 with pgweb

* username: postgres
* database: postgres
* password: postgres

Start postgres daemon:
```
$ /usr/lib/postgresql/13/bin/postgres -D /postgres &
```
(listening at port 5432)

### PostgreSQL examples
* list database: `psql <<< '\list'`
* create table: `psql <<< "CREATE TABLE person (name text, age integer)"`
* insertion: `psql <<< "INSERT INTO person VALUES ('Tom', 19)"`
* query: `psql <<< 'SELECT * FROM person'`
* backup: `pg_basebackup` is used for a running PostgreSQL cluster.

### Run pgweb
```
$ pgweb --no-ssh --host localhost --user postgres --db postgres
```
(listening at port 8081)

### Links
* https://www.postgresql.org/docs/13/index.html
* https://github.com/sosedoff/pgweb
