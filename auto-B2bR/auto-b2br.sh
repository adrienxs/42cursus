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

function	addUser()
{
	id="user42"
	test -f | cat /etc/group | grep user42 | grep $user42 > /dev/null 2>&1
	if [ "$?" == "0" ]; then
		echo -e "${greenColor}[!] '$id group'\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}Creando grupo '$id'...${endColor}\n"
		addgroup user42 > /dev/null 2>&1

		echo -e "${yellowColor}Añadiendo '$user42' a '$id'${endColor}\n"
		adduser $user42 user42 > /dev/null 2>&1
		((c++))
	fi
}

function	sudo()
{
	id="sudo"
	test -f | dpkg -l | grep sudo > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'sudo'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando 'sudo'${endColor}\n"
		apt install -y sudo > /dev/null 2>&1

		echo -e "${yellowColor}Configurando usuarios y grupos...${endColor}\n"
		adduser $user42 sudo > /dev/null 2>&1

		echo -e "${yellowColor}Instalando 'pwquality'${endColor}\n"
		apt install libpam-pwquality > /dev/null 2>&1

		echo -e "${yellowColor}Copiando archivos de configuración...${endColor}\n"
		mkdir /var/log/sudo > /dev/null 2>&1
		touch /var/log/sudo/sudo.log
		cp -b login.defs /etc/ > /dev/null 2>&1
		cp -b sudo_config /etc/sudoers.d/ > /dev/null 2>&1
		cp -b common-password /etc/pam.d/common-password > /dev/null 2>&1

		echo -e "${yellowColor}Reiniciando servicio sshd...${endColor}\n"
		/etc/init.d/sudo restart > /dev/null 2>&1
		((c++))
	fi
}

function	sshd()
{
	id="ssh"
	test -f | dpkg -l | grep openssh-server > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] 'openssh-server'\t\tOK!${endColor}\n"
		((c++))
	else	
		echo -e "${yellowColor}[!] Instalando 'openssh-server'${endColor}\n"
		apt install -y openssh-server > /dev/null 2>&1

		echo -e "${yellowColor}Configurando servidor ssh...${endColor}\n"
		cp -b sshd_config /etc/ssh/sshd_config > /dev/null 2>&1

		echo -e "${yellowColor}Reiniciando servicio sshd...${endColor}\n"
		/etc/init.d/sshd restart > /dev/null 2>&1
		((c++))
	fi
}

function	ufw()
{
	id="ufw"
	test -f | dpkg -l | grep ufw > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		apt install -y ufw > /dev/null 2>&1

		echo -e "${yellowColor}Habilitar firewall '$id' [y]${endColor}\n"
		ufw enable > /dev/null 2>&1

		test -f | ufw status | grep 4242 > /dev/null 2>&1
		if [ $? == "0" ]; then
			echo -e "${greenColor}[!] '4242' allow\t\tOK!${endColor}\n"
		else
			echo -e "${yellowColor}Habilitando puerto 4242...${endColor}\n"
			ufw allow 4242 > /dev/null 2>&1
		fi
		((c++))
	fi
}

function	ft_cron()
{	
	id="cron"
	test -f | dpkg -l | grep cron > /dev/null 2>&1
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$id'\t\t\tOK!${endColor}\n"
		((c++))
	else
		echo -e "${yellowColor}[!] Instalando '$id'${endColor}\n"
		apt install cron -y > /dev/null 2>&1

		echo -e "${yellowColor}[!] Preparando archivos de configuración...${endColor}\n"
		crontab cron_config > /dev/null 2>&1
		touch monitoring.sh > /dev/null 2>&1
		cp -b monitoring.sh /usr/local/bin > /dev/null 2>&1
		chmod 777 /usr/local/bin/monitoring.sh > /dev/null 2>&1

		echo -e "${yellowColor}[!] Reiniciando servicio '$id'...${endColor}\n"
		systemctl restart cron
		((c++))
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
	addUser
	sudo
	ssh
	ufw
	cron
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
