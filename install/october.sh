if [ ! -d $APP_INSTALL_DIRECTORY ]
then

  echo "## Install OctoberCMS"
  su -c "composer create-project october/october $APP_INSTALL_DIRECTORY dev-master" $USERNAME

  # Stop core updates
  rm $APP_INSTALL_DIRECTORY/config/cms.php
  cp /vagrant/install/config/cms.php $APP_INSTALL_DIRECTORY/config/cms.php

  # Set default database connection configuration
  rm $APP_INSTALL_DIRECTORY/config/database.php
  cp /vagrant/install/config/database.php $APP_INSTALL_DIRECTORY/config/database.php

  # Set app defaults
  rm $APP_INSTALL_DIRECTORY/config/app.php
  cp /vagrant/install/config/app.php $APP_INSTALL_DIRECTORY/config/app.php

  # Fix permissions
  chown $USERNAME:www-data -R /var/www

  # Regenerate key
  su -c "cd $APP_INSTALL_DIRECTORY && php artisan key:generate" $USERNAME

fi
