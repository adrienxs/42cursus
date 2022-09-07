#!/bin/bash

# Colores
GREEN="\e[0;32m\033[1m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
CYAN="\e[0;36m\033[1m"
endColor="\033[0m\e[0m"

export DEBIAN_FRONTEND=noninteractive

function	ft_update()
{
	apt update > /dev/null 2>&1
	apt upgrade -y > /dev/null 2>&1
}

function	ft_user42()
{
	id="user42"
	test -f | cat /etc/group | grep "user42"| grep $user42 > /dev/null 2>&1
	if [ "$?" == "0" ]; then
		echo -e "${GREEN}[!] '$id group'\t\tOK!${endColor}\n"
	else
		# Crear grupo 'user42'
		addgroup user42 > /dev/null 2>&1
		# Añadir usuario a 'user42'
		adduser $user42 user42 > /dev/null 2>&1
	fi
	((c++))
}

function	ft_sudo()
{
	id="sudo"
	test -f | dpkg -l | grep "sudo" > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${YELLOW}[!] Instalando '$id'${endColor}\n"
		# Instalar sudo
		apt install -y sudo > /dev/null 2>&1
	fi	
	# Instala 'libpam-pwquality' (strong password policy)
	apt install -y libpam-pwquality > /dev/null 2>&1
	# Añadir usuario a 'sudo'
	adduser $user42 sudo > /dev/null 2>&1
	# Crear directorio 'sudo'
	mkdir /var/log/sudo > /dev/null 2>&1
	# Crear archivo 'sudo.log'
	touch /var/log/sudo/sudo.log > /dev/null 2>&1
	# Copiar archivos de configuración
	cp -b login.defs /etc/ > /dev/null 2>&1
	cp -b sudo_config /etc/sudoers.d/ > /dev/null 2>&1
	cp -b common-password /etc/pam.d/common-password > /dev/null 2>&1
	# Reiniciar servicio 'sudo'
	/etc/init.d/sudo restart > /dev/null 2>&1
	((c++))
}

function	ft_sshd()
{
	id="sshd"
	test -f | dpkg -l | grep "openssh-server" > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!] '$id'\t\t\tOK!${endColor}\n"
	else	
		echo -e "${YELLOW}[!] Instalando '$id'${endColor}\n"
		# Instalar servidor ssh
		apt install -y openssh-server > /dev/null 2>&1
	fi	
	# Copiar archivos de configuración
	cp -b sshd_config /etc/ssh/sshd_config > /dev/null 2>&1
	# Reiniciar servicio 'sshd'
	/etc/init.d/sshd restart > /dev/null 2>&1
	((c++))
}

function	ft_ufw()
{
	id="ufw"
	test -f | dpkg -l | grep "ufw" > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${YELLOW}[!] Instalando '$id'${endColor}\n"
		# Instalar 'ufw'
		apt install -y ufw > /dev/null 2>&1
		# Activar 'ufw'
		ufw enable > /dev/null 2>&1
	fi
	test -f | ufw status | grep "4242" > /dev/null 2>&1
	if [ $? == "1" ]; then
	# Permitir puerto '4242'
	ufw allow 4242 > /dev/null 2>&1
	fi
	((c++))
}

function	ft_cron()
{	
	id="cron"
	test -f | dpkg -l | grep " cron " > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!] '$id'\t\t\tOK!${endColor}\n"
	else
		echo -e "${YELLOW}[!] Instalando '$id'${endColor}\n"
		# Instalar 'cron'
		apt install cron -y > /dev/null 2>&1
	fi
	# Preparar archivos de configuración
	crontab cron_config > /dev/null 2>&1
	# Script 'monitoring.sh'
	echo "echo crontab_OK!" > monitoring.sh
	cp -b monitoring.sh /usr/local/bin > /dev/null 2>&1
	chmod 777 /usr/local/bin/monitoring.sh > /dev/null 2>&1
	# Reiniciar servicio 'cron'
	systemctl restart cron > /dev/null 2>&1
	((c++))
}

function	helpPanel()
{
	echo -e "${CYAN}# Creado por asirvent y supervisado por cpeset-c.${endColor}"
	echo -e "${YELLOW}# Instrucciones: \"auto-b2br.sh -i\" para iniciar la instalación.${endColor}\n"
}

function	ft_install()
{	
	let c="0"
	ft_user42
	ft_sudo
	ft_sshd
	ft_cron
	ft_ufw
	if [ $c == "5" ]; then
		echo -e "${YELLOW}Instalacion completada${endColor}\n"
	fi
}

# Main function
cat banner.txt
if [ "$(id -u)" == "0" ]; then
	declare -i counter="0";
	if [ -z "$1" ]; then
		helpPanel
	else
		if [ $1 == "-i" ]; then
			user42="0"
			while [ $(cat /etc/passwd | grep $user42 | wc -l) != "1"  ]; do
				read -p "Introduce tu nombre de usuario (grupo user42): " user42
				if [ $(cat /etc/passwd | grep $user42 | wc -l) == "0" ]; then
				echo -e "${RED}[!] Error: el usuario '$user42' no existe.${endColor}\n"
				fi
			done
		echo -e "${YELLOW}Preparando instalación...${endColor}\n"
		ft_install
		else
			helpPanel
		fi
	fi
else
	echo "${RED}Permiso denegado.${endColor}"
fi
