#!/bin/bash

# Export any system variables here
export USERNAME=october
export APP_INSTALL_DIRECTORY=/var/www/october
export MYSQL_ROOT_PASSWORD=october
export MYSQL_DB_NAME=october
export MYSQL_DB_USER=october
export MYSQL_DB_PASSWORD=october
export PHP_VERSION=3.14.2

# Make all vagrant files executable
chmod +x /vagrant/*.sh
chmod +x /vagrant/install/*.sh

# Setup user
/vagrant/install/shared.sh

chown "$USERNAME:$USERNAME" -R "/home/$USERNAME"

# Install and configure Nginx
/vagrant/install/nginx.sh

# Install and configure HHVM
/vagrant/install/hhvm.sh

# Install and configure mariadb
/vagrant/install/mysql.sh

# Install Composer
/vagrant/install/composer.sh

# Install OctoberCMS
/vagrant/install/october.sh

# Save some space
apt-get -y autoremove

echo " "
echo "######## Vagrant Provisioning Complete ########"
echo " "
echo "   Add to your local /etc/hosts:"
echo "     55.55.55.50 october.dev www.october.dev"
echo " "
echo "   Open the october.dev app:"
echo "     $ open http://www.october.dev"
echo " "
