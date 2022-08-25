#!/bin/bash

trap ctrl_c INT

function	ctrl_c()
{
	echo "[!] Saliendo..."
}

function	checkFile()
{
	test -f | $arg1 | grep $arg2
}

function	verify()
{
	checkError="0"
	checkFile
	if [ $? == "0" ]; then
		echo -e "[!] Verify'$arg2'\t\tOK!\n"
		checkError="0"
	else
		echo -e "[!] Verify'$arg2'\t\tKO!\n"
		checkError="1"
	fi
}

function	sudo()
{
	
	arg1"dpkg -l" arg2=" sudo " checkFile
	if [ $? == "0" ]; then
		echo -e "[!] 'sudo'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'sudo'\n"
		apt install -y sudo
		verify
	fi
}

function	ssh()
{
	arg1="dpkg -l" arg2=" openssh-server " checkFile
	if [ $? == "0" ]; then
		echo -e "[!] 'openssh-server'\t\tOK!\n"
	else	
		echo -e "[!] Instalando 'openssh-server'\n"
		apt install -y openssh-server
		verify
	fi

	#SSH-SERVER CONFIG
	#-
}

function	ufw()
{
	arg1="dpkg -l" arg2=" ufw " checkFile
	if [ $? == "0" ]; then
		echo -e "[!] 'ufw'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'ufw'\n"
		apt install -y ufw
		verify
	fi

	#UFW CONFIG
	arg1="ufw status" arg2="active" checkFile
	if [ $? == "0" ]; then
		echo -e "[!] 'ufw'\t\tACTIVE\n"
	else
		ufw enable
		verify
	fi

	arg1="ufw status" arg2="4242" checkFile	
	if [ $? == "0"]; then
		echo -e "[!] Puerto 4242\t\tALLOW\n"
	else
		ufw allow 4242
		verify
	fi
}

function	ft_cron()
{
	arg1="dpkg -l" arg2=" cron " checkFile	
	if [ $? == "0" ]; then
		echo -e "[!] '$arg2'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando'$arg2'\n"
		apt install cron -y
		verify
	fi

	#CRON CONFIG
	if [ $? != "0" ]; then
		cp -b ./script/monitoring.sh /usr/local/bin/monitoring.sh
		crontab b2br-cron
		systemctl restart cron
	fi
}

function	helpPanel()
{
	echo -e "Panel de Ayuda\n\n"
	echo -e "Uso: <Nombre del Programa> -f <funcion>\n
			-f install: Instala y configura todos los programas y servicios necesarios.\n
			-f verify: Verifica los paquetes instalados, servicios activos y archivos de configuracion.\n"
}

# Main function

cat banner.txt

if [ "$(id -u)" == "0" ]; then

	declare -i counter="0";
	while getopts ":f:" arg; do
		case $arg in
			f) function=$OPTARG; let counter+=1 ;;
		esac
	done

	if [ $counter -ne 1 ]; then
		helpPanel
	else
		if [ $function == "install" ]; then
			sudo ssh ufw
		elif [ $function == "verify" ]; then
				
		else
			helpPanel
		fi
	fi

else
	echo "Permiso denegado"
fi
	


