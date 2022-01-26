FROM debian:buster

ENV AUTOINDEX=on

RUN set -eux; \
    apt-get update ; \
	apt-get install -y nginx mariadb-server curl ; \
	apt-get -y install php7.3-fpm php7.3 php7.3.xml php7.3-mysql php7.3-common php7.3-curl; \
	apt-get install -y vim;

RUN curl -fsSL -o phpMyAdmin.tar.xz  https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.xz ; \
	tar -xf phpMyAdmin.tar.xz -C /var/www/html ; \
    mv /var/www/html/phpMyAdmin-5.1.0-all-languages /var/www/html/phpmyadmin ; \
	chown -R www-data:www-data /var/www/html/phpmyadmin ; 

RUN apt-get install openssl ; \
	openssl req -x509 -days 365 -newkey rsa:2048 -nodes -keyout  /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt\
	-subj /C=FR/ST=ILEDEFRANCE/L=PARIS/O=42/OU=FT_SERVER/CN=localhost ;

COPY srcs /srcs

#wordpress 
RUN curl -LO https://wordpress.org/latest.tar.gz ; \
	tar xzvf latest.tar.gz -C /var/www/html ; \
	service mysql start ; \
	mariadb < /srcs/sqlconfig.sql ; \
	chown -R www-data:www-data /var/www/html ; \
	find /var/www/html -type d -exec chmod 755 {} \; ;\
	find /var/www/html -type f -exec chmod 644 {} \;

#nginx config
RUN rm -rf /etc/nginx/sites-available/default ; \
	cp /srcs/default /etc/nginx/sites-available/default ;

EXPOSE 80

ENTRYPOINT ["bash", "/srcs/start.sh"]

CMD ["nginx", "-g", "daemon off;"]
