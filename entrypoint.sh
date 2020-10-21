init() {
	MNT_PATH=$1
	# setup postgres
	chown -R postgres:postgres /postgres/*
	sudo -u postgres /usr/lib/postgresql/13/bin/initdb -U postgres -D $MNT_PATH
	sed -i '/port =/c port = 5432' $MNT_PATH/postgresql.conf
	sed -i "/listen_addresses =/c listen_addresses = '*'" $MNT_PATH/postgresql.conf

	grep 'AUTOADD' $MNT_PATH/pg_hba.conf
	if [ ! "$?" -eq 0 ]; then
		echo "host all all 0.0.0.0/0 trust # AUTOADD" >> $MNT_PATH/pg_hba.conf
	fi
	chown -R postgres:postgres /postgres/*
}

init /postgres/data
sudo -u postgres /usr/lib/postgresql/13/bin/postgres -D /postgres/data &
sleep 16
pgweb --no-ssh --host localhost --user postgres --db postgres --listen 80 --ssl=disable --bind 0.0.0.0
