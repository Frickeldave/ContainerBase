#!/bin/sh

INITIALSTART=0

echo "running start.sh script of mariadb"

# set initstart variable
if [ ! -f /home/appuser/data/firststart.flg ]
then 
    echo "first start, set initialstart variable to 1"
    INITIALSTART=1
    echo `date +%Y-%m-%d_%H:%M:%S_%z` > /home/appuser/data/firststart.flg
else
	echo "It's not the first start, skip first start section"
fi

# Create config file
echo "Create mariadb configuration file with following settings"
echo "Port:				${MDB_PORT}"
echo "Collation: 		${MDB_COLLATION}"
echo "Character-set: 	${MDB_CHARACTERSET}"
echo "[mysqld]" > /home/appuser/data/mariadb.cnf
echo "port=${MDB_PORT}" >> /home/appuser/data/mariadb.cnf
echo "socket=/home/appuser/app/mariadb.socket" >> /home/appuser/data/mariadb.cnf
echo "pid-file=/home/appuser/app/mariadb.pid" >> /home/appuser/data/mariadb.cnf
echo "datadir=/home/appuser/data/mariadb/db" >> /home/appuser/data/mariadb.cnf
echo "symbolic-links=0" >> /home/appuser/data/mariadb.cnf
echo "bind-address=0.0.0.0" >> /home/appuser/data/mariadb.cnf
echo "console=1" >> /home/appuser/data/mariadb.cnf
echo "general_log=0" >> /home/appuser/data/mariadb.cnf
echo "general_log_file==/home/appuser/data/mariadb/log/mariadb.log" >> /home/appuser/data/mariadb.cnf
echo "log_error=/home/appuser/data/mariadb/log/mariadb_error.log" >> /home/appuser/data/mariadb.cnf
echo "collation-server=${MDB_COLLATION}" >> /home/appuser/data/mariadb.cnf
echo "character-set-server=${MDB_CHARACTERSET}" >> /home/appuser/data/mariadb.cnf

if [ "$INITIALSTART" == "1" ]
then
	echo "Initialize MariadB data, when it was never done before"
	mysql_install_db --defaults-file=/home/appuser/data/mariadb.cnf --auth-root-authentication-method=normal
	echo "Wait 5s"
	sleep 5s
	
	echo "Start mariaDB one time to inject initial changes"
	mysqld --defaults-file=/home/appuser/data/mariadb.cnf & #--skip-grant-tables --skip-networking

	echo "to be sure that the server is up and running, lets wait a bit"
	echo "Wait 5s"
	sleep 5s

	echo "patch setup.sql based on given environment variables"
	sed -i -e "s/#MDB_ROOTPWD#/${MDB_ROOTPWD}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_ADMINUSER#/${MDB_ADMINUSER}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_BACKUPUSER#/${MDB_BACKUPUSER}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_ADMINPWD#/${MDB_ADMINPWD}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_BACKUPPWD#/${MDB_BACKUPPWD}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_HEALTHUSER#/${MDB_HEALTHUSER}/g" /home/appuser/app/setup.sql
	sed -i -e "s/#MDB_HEALTHPWD#/${MDB_HEALTHPWD}/g" /home/appuser/app/setup.sql

	echo "inject changes"
	mysql -v -h 127.0.0.1 -u root -P ${MDB_PORT} < /home/appuser/app/setup.sql
	rm -f /home/appuser/app/setup.sql

	echo "patch appdb.sql based on given environment variables"
	sed -i -e "s/#MDB_APPDB#/${MDB_APPDB}/g" /home/appuser/app/appdb.sql
	sed -i -e "s/#MDB_CHARACTERSET#/${MDB_CHARACTERSET}/g" /home/appuser/app/appdb.sql
	sed -i -e "s/#MDB_COLLATION#/${MDB_COLLATION}/g" /home/appuser/app/appdb.sql
	sed -i -e "s/#MDB_APPDB_USER#/${MDB_APPDB_USER}/g" /home/appuser/app/appdb.sql
	sed -i -e "s/#MDB_APPDB_PWD#/${MDB_APPDB_PWD}/g" /home/appuser/app/appdb.sql

	echo "inject changes"
	mysql -v -h 127.0.0.1 -u root -P ${MDB_PORT} -p${MDB_ROOTPWD} < /home/appuser/app/appdb.sql
	rm -f /home/appuser/app/appdb.sql

	echo "let us wait a few seconds more to be sure that everything is applied"
	sleep 5s

	echo "kill MariaDB"
	ps -ef | grep mysql | grep -v grep | awk '{print $1}' | xargs kill -9

	echo `date +%Y-%m-%d_%H:%M:%S_%z` > /home/appuser/data/firststart_finished.flg
else
	echo "It's not the first start, skip first start section"
fi

echo "Start MariaDB process finally"
mysqld --defaults-file=/home/appuser/data/mariadb.cnf