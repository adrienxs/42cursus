# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto-bonus.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/29 19:50:28 by asirvent          #+#    #+#              #
#    Updated: 2022/11/29 19:50:35 by asirvent         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#figlet -c auto-bonus B2bR
echo -e "\n"
#!/bin/bash

#---
#> /dev/null 2>&1
#---

# Colores
GREEN="\e[0;32m\033[1m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
CYAN="\e[0;36m\033[1m"
endColor="\033[0m\e[0m"

#Main (aun no se ha probado en vm)
ufw allow 80
ufw allow 8080
apt install mariadb-server -y
mysql_secure_installation
cp -b wpdb /var/lib/mysql/
	#---
	##Crear base de datos
	#CREATE DATABASE wpdb;

	##Crear uuario y contraseña
	#CREATE USER 'user'@'localhost' IDENTIFIED BY 'pass';

	##Dar acceso completo al usuario 'user' a la base de datos 'wpdb'
	#GRANT ALL ON wpdb.* TO 'user'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;

	##Leer y recargar privilegios
	#FLUSH PRIVILEGES;

	##Salir de MariaDB
	#EXIT;
	#---
apt install php-cgi php-mysql lighttpd -y
lighttpd-enable-mod fastcgi
lighttpd-enable-mod fastcgi-php
lighty-enable-mod accesslog
cp -b lighttpd.conf /etc/lighttpd/lighttpd.conf
systemctl start lighttpd
apt install wget
cd /tmp/ && wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp -R wordpress/* /var/www/html
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	#---
	#define( 'DB_NAME', 'wpdb' );
	#define( 'DB_USER', 'user' );
	#define( 'DB_PASSWORD', 'pass' );
	#---
cp -b wp-config.php /var/www/html/wp-config.php
