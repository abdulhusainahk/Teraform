#!/bin/bash
# install mysql server
sudo apt install mysql-server -y

sudo echo -e "server-id = 2\nlog_bin = /var/log/mysql/mysql-bin.log\ngtid_mode = ON\nenforce-gtid-consistency = ON\n log-replica-updates=ON\nskip-replica-start=ON\nbinlog_do_db = db\nrelay-log = /var/log/mysql/mysql-relay-bin.log" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

sudo mysql -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='$1',SOURCE_USER='replica_user',SOURCE_PASSWORD='replica',SOURCE_AUTO_POSITION=1;"
sudo mysql -e "start replica;"













