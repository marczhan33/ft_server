if [ "$AUTOINDEX" = "on" ]
then
	sed -i 's/autoindex off;/autoindex on;/g' /etc/nginx/sites-available/default
else
	sed -i 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/default
fi
service mysql start
service php7.3-fpm start
rm -rf /var/www/html/index.nginx-debian.html
exec "$@"
