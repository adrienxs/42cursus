#!/bin/bash

# Colores
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
endColor="\033[0m\e[0m"

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function	ctrl_c()
{
	echo "Saliendo"
}

function	ft_user42()
{
	id="user42"
	test -f | cat /etc/group | grep "user42" | grep $user42
	if [ "$?" == "0" ]; then
		echo -e "${greenColor}[!] '$id group'\t\tOK!${endColor}\n"
	else
		# Crear grupo 'user42'
		addgroup user42
		# Añadir usuario a 'user42'
		adduser $user42 user42
	fi
	((c++))
}

function	ft_sudo()
{
	id="sudo"
	test -f | dpkg -l | grep "sudo"
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		# Instalar sudo
		apt install -y sudo
	fi	
	# Instala 'libpam-pwquality' (strong password policy)
	apt install -y libpam-pwquality
	# Añadir usuario a 'sudo'
	adduser $user42 sudo
	# Crear directorio 'sudo'
	mkdir /var/log/sudo
	# Crear archivo 'sudo.log'
	touch /var/log/sudo/sudo.log
	# Copiar archivos de configuración
	cp -b login.defs /etc/
	cp -b sudo_config /etc/sudoers.d/
	cp -b common-password /etc/pam.d/common-password
	# Reiniciar servicio 'sudo'
	/etc/init.d/sudo restart
	((c++))
}

function	ft_sshd()
{
	id="sshd"
	test -f | dpkg -l | grep "openssh-server"
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
	else	
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		# Instalar servidor ssh
		apt install -y openssh-server
	fi	
	# Copiar archivos de configuración
	cp -b sshd_config /etc/ssh/sshd_config
	# Reiniciar servicio 'sshd'
	/etc/init.d/sshd restart
	((c++))
}

function	ft_ufw()
{
	id="ufw"
	test -f | dpkg -l | grep "ufw"
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		# Instalar 'ufw'
		apt install -y ufw
	fi
	# Activar firewall 'ufw'
	test -f | status ufw | grep -w "active"
	if [ $? == "0" ]; then
	# Permitir puerto '4242'
	ufw allow 4242	
	else
	# Habilitar 'ufw'
	ufw enable
	fi
	((c++))
}

function	ft_cron()
{	
	id="cron"
	test -f | dpkg -l | grep " cron "
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		# Instalar 'cron'
		apt install cron -y
	fi
	# Preparar archivos de configuración
	crontab cron_config
	# Script 'monitoring.sh'
	echo "echo crontab_OK!" > monitoring.sh
	cp -b monitoring.sh /usr/local/bin
	chmod 777 /usr/local/bin/monitoring.sh
	# Reiniciar servicio 'cron'
	systemctl restart cron
	((c++))
}

function	helpPanel()
{
	echo -e "Panel de Ayuda\n"
	echo -e "Uso: auto-b2br.sh -f [funcion]\n
	-f install: Instala y configura todos los programas y servicios necesarios.\n
	-f verify: Verifica los paquetes instalados, servicios activos y archivos de configuracion.\n"
}

function	ft_install()
{	
	let c="0"
	ft_user42
	ft_sudo
	ft_sshd
	ft_ufw
	ft_cron
	if [ $c == "5" ]; then
		echo -e "${yellowColor}Instalacion completada${endColor}\n"
	fi
}

# Main function
cat banner.txt
if [ "$(id -u)" == "0" ]; then
	install="0"
	verify="0"
	declare -i counter="0";
	while getopts ":f:" arg; do
		case $arg in
			f) install=$OPTARG; let counter+=1 ;;
		esac
	done
	if [ $counter -ne 1 ]; then
		helpPanel
	else
		if [ $install == "install" ]; then
			user42="0"
			while [ $(cat /etc/passwd | grep $user42 | wc -l) != "1"  ]; do
				read -p "Introduce tu nombre de usuario (grupo user42): " user42
				if [ $(cat /etc/passwd | grep $user42 | wc -l) == "0" ]; then
				echo -e "${redColor}[!] Error: el usuario '$user42' no existe.${endColor}\n"
				fi
			done
		echo -e "${yellowColor}Preparando instalación...${endColor}\n"
		apt update
		apt upgrade -y
		ft_install
		else
			helpPanel
		fi
	fi
else
	echo "${yellowColor}Permiso denegado."
fi
