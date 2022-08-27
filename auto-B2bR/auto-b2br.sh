#!/bin/bash

#Colours
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
endColor="\033[0m\e[0m"

trap ctrl_c INT

function	ctrl_c()
{
	echo "Saliendo"
}

# function	checkFile()
# {
# 	test -f | $arg2 | $arg3 | $arg4 | $arg5
# }

# function	ft_verify()
# {
# 	checkFile
# 	if [ $? == "0" ]; then
# 		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
# 		((c++))
# 	else
# 		echo -e "${redColor}[!] '$id'\t\t\tKO!${endColor}\n"
# 	fi
# }

function	addUser42()
{
	id="user42"
	test -f | cat /etc/group | grep user42 | grep $user42 > /dev/null 2>&1
	if [ "$?" == "0" ]; then
		echo -e "${greenColor}[!] '$id group'\t\tOK!${endColor}\n"
		((c++))
	else
		addgroup user42 > /dev/null 2>&1
		echo -e "${yellowColor}Creando grupo '$id'...${endColor}\n"
		adduser $user42 user42 > /dev/null 2>&1
		echo -e "${yellowColor}Añadiendo '$user42' a '$id'${endColor}\n"
	fi
}

function	ft_sudo()
{
	id="sudo"
	test -f | dpkg -l | grep sudo> /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'sudo'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando 'sudo'${endColor}\n"
		apt install -y sudo > /dev/null 2>&1
		echo -e "${yellowColor}Añadiendo '$user42' a '$id'${endColor}\n"
		adduser $user42 sudo > /dev/null 2>&1
		echo -e "${yellowColor}'$id' strong pass${endColor}\n"
		apt install libpam-pwquality > /dev/null 2>&1
		echo -e "${yellowColor}Copiando archivos de configuración...${endColor}\n"
		mkdir /var/log/sudo
		touch /var/log/sudo/sudo.log
		cp -b sudo_config /eth/sudoer.d/
		cp -b common-password /etc/pam.d/common-password
		echo -e "${yellowColor}Reiniciando servicio sshd...${endColor}\n"
		/etc/init.d/sudo restart
	fi
}

function	ft_ssh()
{
	id="ssh"
	test -f | dpkg -l | grep openssh-server> /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'openssh-server'\t\tOK!${endColor}\n"
		((c++))
	else	
		echo -e "${yellowColor}[!] Instalando 'openssh-server'${endColor}\n"
		apt install -y openssh-server > /dev/null 2>&1
		cp -b sshd_config /eth/ssh/sshd_config
		echo -e "${yellowColor}Reiniciando servicio sshd...${endColor}\n"
		/etc/init.d/sshd restart
	fi
}

function	ft_ufw()
{
	id="ufw"
	test -f | dpkg -l | grep ufw > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'ufw'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando 'ufw'${endColor}\n"
		apt install -y ufw > /dev/null 2>&1

		test -f | systemctl status ufw | grep active > /dev/null 2>&1
		if [ $? == "0" ]; then
			echo -e "${greenColor}[!] 'ufw' enable\t\t\tOK!${endColor}\n"
			else
			ufw enable
		fi

		test -f | ufw status | grep 4242 > /dev/null 2>&1
		if [ $? == "0" ]; then
			echo -e "${greenColor}[!] '4242' allow\t\tOK!${endColor}\n"
		else
			ufw allow 4242 > /dev/null
		fi
	fi
}

function	ft_cron()
{	
	test -f | dpkg -l | grep cron > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'cron'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando 'cron'${endColor}\n"
		apt install cron -y > /dev/null 2>&1
		crontab cron_42config
		cp -b monitoring.sh /usr/local/bin
		chmod 777 /usr/local/bin/monitoring.sh
		systemctl restart cron
	fi
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
	#apt install man  > /dev/null 2>&1
	#apt install vim  > /dev/null 2>&1
	addUser
	ft_sudo
	ft_ssh
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
		#apt update > /dev/null 2>&1
		#apt upgrade -y > /dev/null 2>&1
		ft_install
		else
			helpPanel
		fi
	fi
else
	echo "${yellowColor}Permiso denegado."
fi