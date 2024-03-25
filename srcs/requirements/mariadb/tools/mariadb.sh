#!/bin/sh

rc-service mariadb start

mariadb -e "DROP DATABASE test;"
mariadb -e "DELETE FROM mysql.user WHERE User='';"
mariadb -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mariadb -e "FLUSH PRIVILEGES;"

mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT'"
mariadb -p$DB_ROOT -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mariadb -p$DB_ROOT -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
mariadb -p$DB_ROOT -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
mariadb -p$DB_ROOT -e "FLUSH PRIVILEGES;"

rc-service mariadb stop
exec mariadbd