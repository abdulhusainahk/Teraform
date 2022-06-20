#!/bin/bash

# install mysql server
sudo apt install mysql-server -y

#allow access to replica database on  port 3306
sudo ufw allow from $1 to any port 3306

#fetch ip address from the system
ip_address=$(/sbin/ifconfig eth0 | grep 'inet ' | cut -d: -f2 | awk '{print $2}')

#add config to mysqld.conf file
sudo sed -i 's/^bind-address/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo echo -e "bind-address = $(echo $ip_address)\nserver-id = 1\nlog_bin = /var/log/mysql/mysql-bin.log\ngtid_mode = ON\nenforce-gtid-consistency = ON\nbinlog_do_db = db" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf
#restart mysql server
sudo systemctl restart mysql.service

sudo mysql -e "CREATE USER 'replica_user'@'$1' IDENTIFIED WITH mysql_native_password BY 'replica';"

sudo mysql -e " GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'$1';"

sudo mysql -e "FLUSH PRIVILEGES;"

sudo mysql -e "create database db;"

sudo mysql -e "create table db.table1(col1 varchar(20));"

sudo mysql -e "insert into db.table1 values('hii there');"
