echo "## Installing Nginx"

apt-get install nginx -y

if [ ! -e "/etc/nginx/sites-available/october.dev" ]
then
  touch /etc/nginx/sites-available/october.dev

  cat > /etc/nginx/sites-available/october.dev <<EOL
  server {
    listen 80 default_server;
    listen [::]80 default_server ipv6only=on;

    root $APP_INSTALL_DIRECTORY;
    index index.php;

    server_name october.dev www.october.dev;

    location / {
      try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    rewrite ^themes/.*/(layouts|pages|partials)/.*.htm /index.php break;
    rewrite ^bootstrap/.* /index.php break;
    rewrite ^config/.* /index.php break;
    rewrite ^vendor/.* /index.php break;
    rewrite ^storage/cms/.* /index.php break;
    rewrite ^storage/logs/.* /index.php break;
    rewrite ^storage/framework/.* /index.php break;
    rewrite ^storage/temp/protected/.* /index.php break;
    rewrite ^storage/app/uploads/protected/.* /index.php break;

    location ~ \.(hh|php)$ {
      include fastcgi_params;
      try_files $uri /index.php =404;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
    }
  }
EOL

  # Remove default configuration files
  echo "## Removing default Nginx configuration"
  rm /etc/nginx/sites-available/default
  rm /etc/nginx/sites-enabled/default

  ln -s /etc/nginx/sites-available/october.dev /etc/nginx/sites-enabled/

  adduser $USERNAME www-data
  chown $USERNAME:www-data -R /var/www

fi

service nginx reload
