# TODO: Better check for MySQL install version
installed_version=$(which mysql)
if [[ $installed_version != "/usr/bin/mysql" ]]; then
  echo "## Installing MySQL"
  debconf-set-selections <<< "mariadb-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
  debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
  apt-get -y install mariadb-server
  apt-get -y install mysqltuner

  # Allow external MySQL connections
  sed -i "s/bind-address\t\t\=\s127.0.0.1/bind-address\t\t\= 0.0.0.0/g" /etc/mysql/my.cnf

  # Create `october` database
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE DATABASE $MYSQL_DB_NAME;"

  # Add `october` MySQL user with remote access
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE USER '$MYSQL_DB_USER'@'localhost' IDENTIFIED BY '$MYSQL_DB_PASSWORD';"
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE USER '$MYSQL_DB_USER'@'%' IDENTIFIED BY '$MYSQL_DB_PASSWORD';"

  # Grant access to `october` database
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="GRANT ALL ON $MYSQL_DB_NAME.* TO '$MYSQL_DB_USER'@'localhost';"
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="GRANT ALL ON $MYSQL_DB_NAME.* TO '$MYSQL_DB_USER'@'%';"

  # Flush privileges
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="FLUSH PRIVILEGES;"

  # Restart MySQL Server
  service mysql restart

  # Install default config
  mysql -u root --password="$MYSQL_ROOT_PASSWORD" --execute="use $MYSQL_DB_NAME; source /vagrant/install/config/october.sql;"

fi
