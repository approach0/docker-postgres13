DATA_PATH=/postgres/data

setup_postgres() {
	chown -R postgres:postgres /postgres/*
	sudo -u postgres /usr/lib/postgresql/13/bin/initdb -U postgres -D $DATA_PATH
	sed -i '/port =/c port = 5432' $DATA_PATH/postgresql.conf
	sed -i "/listen_addresses =/c listen_addresses = '*'" $DATA_PATH/postgresql.conf

	grep 'AUTOADD' $DATA_PATH/pg_hba.conf
	if [ ! "$?" -eq 0 ]; then
		echo "host all all 0.0.0.0/0 trust # AUTOADD" >> $DATA_PATH/pg_hba.conf
	fi
	chown -R postgres:postgres /postgres/*
}

dump_custom_format() {
	BKUP_FILE=$DATA_PATH/$1
	sudo -u postgres pg_dump -Fc postgres > $BKUP_FILE
}

clean_and_restore() {
	BKUP_FILE=$DATA_PATH/$1
	sudo -u postgres pg_restore -cd postgres $BKUP_FILE
}

backup() {
	dump_custom_format $(date --iso-8601).dump
	# remove dumps that are older than 7 days
	find $DATA_PATH -name '*.dump' -mtime +7 -exec rm -f {} \;
	date > $DATA_PATH/cron-test.log
}

cron_test() {
	date >> $DATA_PATH/cron-test.log
}

setup_and_serve() {
	setup_postgres

	# At 03:01 each day
	(crontab -l ; echo "1 3 * * * /postgres/entrypoint.sh backup") | sort - | uniq - | crontab -
	# every minute
	(crontab -l ; echo "* * * * * /postgres/entrypoint.sh cron_test") | sort - | uniq - | crontab -
	# spawn a cron daemon
	cron && pstree

	sudo -u postgres /usr/lib/postgresql/13/bin/postgres -D $DATA_PATH &
	sleep 32 # wait until pg is ready to serve
	pgweb --no-ssh --host localhost --user postgres --db postgres --listen 80 --ssl=disable --bind 0.0.0.0
}

$@
