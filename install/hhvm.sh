# Install HHVM

if [ ! -d "/etc/hhvm" ]
then

  echo "## Installing HHVM"
  apt-get install software-properties-common -y
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
  sudo add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
  sudo apt-get update
  apt-get install hhvm -y
  /usr/share/hhvm/install_fastcgi.sh
  rm /etc/apache2/mods-available/hhvm_proxy_fcgi.conf
  touch /etc/apache2/mods-available/hhvm_proxy_fcgi.conf

  if [ ! -e "/etc/hhvm/october.ini" ]
  then

    cat >> /etc/hhvm/dogids.ini <<EOL
; hhvm specific
hhvm.enable_short_tags = true
hhvm.enable_zend_compat = true
hhvm.enable_asp_tags = true

; php options
session.auto_start = false
session.cookie_lifetime = 31536000
session.use_cookies = true
session.use_only_cookies = true
session.name = FWCSESSID
memory_limit = 128M
EOL
  fi

  echo "## Setting HHVM to run at start"
  update-rc.d hhvm defaults

  service hhvm restart
  service nginx restart

fi
