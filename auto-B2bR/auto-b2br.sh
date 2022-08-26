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

function	checkFile()
{
	test -f | $arg1 | grep $arg2 > /dev/null 2>&1
}

function	ft_verify()
{
	checkFile
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] Verify '$arg2'\t\tOK!${endColor}\n"
		let c+=1
	else
		echo -e "${redColor}[!] Verify '$arg2'\t\tKO!${endColor}\n"
	fi
}

function	addUser()
{
	addgroup user42 > /dev/null 2>&1
	adduser $user42 user42 > /dev/null 2>&1
	if [ "$(test -f | cat /etc/group | grep $user42 | grep user42 | wc -l)" == "1" ]; then
		echo -e "${greenColor}[!] ' user42 Group '\t\tOK!${endColor}\n"
		let c+=1
	else
		echo -e "${redColor}[!] ' user42 Group '\t\tKO!${endColor}\n"
	fi
}


function	ft_sudo()
{
	arg1="dpkg -l"; arg2=" sudo "; checkFile;
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$arg2'\t\t\tOK!${endColor}\n"
		let c+=1
	else
		echo -e "${yellowColor}[!] Instalando '$arg2'${endColor}\n"
		apt install -y sudo > /dev/null 2>&1
	fi
}


function	ft_ssh()
{	
	arg1="dpkg -l"; arg2=" openssh-server "; checkFile;	
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$arg2'\t\tOK!${endColor}\n"
		let c+=1
	else	
		echo -e "${yellowColor}[!] Instalando '$arg2'${endColor}\n"
		apt install -y openssh-server > /dev/null 2>&1
	fi
}

function	ft_ufw()
{
	arg1="dpkg -l"; arg2=" ufw "; checkFile;	
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$arg2'\t\t\tOK!${endColor}\n"
		let c+=1
	else
		echo -e "${yellowColor}[!] Instalando '$arg2'${endColor}\n"
		apt install -y ufw > /dev/null 2>&1
		ft_verify

		arg1="ufw status"; arg2="inactive"; checkFile;
		if [ $? == "0" ]; then
			ufw enable
		fi

		arg1="ufw status"; arg2="4242"; checkFile;
		if [ $? == "0" ]; then
			echo -e "${greenColor}[!] Puerto $arg2\t\tALLOW\n"
		else
			ufw allow 4242 > /dev/null
		fi
	fi
}

function	ft_cron()
{	
	arg1="dpkg -l"; arg2=" cron "; checkFile;
	if [ $? == "0" ]; then
		echo -e "${greenColor}[!] '$arg2'\t\t\tOK!${endColor}\n"
		let c+=1
	else
		echo -e "${yellowColor}[!] Instalando '$arg2'${endColor}\n"
		apt install cron -y > /dev/null 2>&1
		#crontab b2br-cron
		#cp -b monitoring.sh /usr/local/bin
		#chmod 777 /usr/local/bin/monitoring.sh
		#systemctl restart cron
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
	ft_sudo
	ft_ssh
	ft_ufw
	ft_cron
	if [ $c == "5" ]; then
		echo -e "${greenColor}[!] ' auto-B2bR [100%] '\tOK!${endColor}\n"
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