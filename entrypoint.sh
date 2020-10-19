init() {
	# setup postgres
	chown -R postgres:postgres /postgres/*
	sudo -u postgres /usr/lib/postgresql/13/bin/initdb -D /postgres -U postgres/data
	sed -i '/port =/c port = 5432' /postgres/postgresql.conf
	sed -i "/listen_addresses =/c listen_addresses = '*'" /postgres/postgresql.conf
}

init
sudo -u postgres /usr/lib/postgresql/13/bin/postgres -D /postgres/data &
pgweb --no-ssh --host localhost --user postgres --db postgres
