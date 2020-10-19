init() {
	# setup postgres
	chown -R postgres:postgres /postgres/*
	sudo -u postgres /usr/lib/postgresql/13/bin/initdb -U postgres -D /postgres/data
	sed -i '/port =/c port = 5432' /postgres/data/postgresql.conf
	sed -i "/listen_addresses =/c listen_addresses = '*'" /postgres/data/postgresql.conf
}

init
sudo -u postgres /usr/lib/postgresql/13/bin/postgres -D /postgres/data &
sleep 16
pgweb --no-ssh --host localhost --user postgres --db postgres --listen 80 --ssl=disable --bind 0.0.0.0
