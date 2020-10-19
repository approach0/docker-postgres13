init() {
	# setup postgres
	chown postgres:postgres /postgres
	chown -R postgres:postgres /postgres/*
	/usr/lib/postgresql/13/bin/initdb -D /postgres -U postgres
	sed -i '/port =/c port = 5432' /postgres/postgresql.conf
	sed -i "/listen_addresses =/c listen_addresses = '*'" /postgres/postgresql.conf
}

init
/usr/lib/postgresql/13/bin/postgres -D /postgres &
pgweb --no-ssh --host localhost --user postgres --db postgres
