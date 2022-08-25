#!/bin/bash

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
	if [ $? == "0" ]; then
		echo -e "[!] Verify '$arg2'\t\tOK!\n"
	else
		echo -e "[!] Verify '$arg2'\t\tKO!\n"
	fi
}

function	ft_sudo()
{
	arg1="dpkg -l" arg2=" sudo " checkFile
	if [ $? == "0" ]; then
		echo -e "[!] 'sudo'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'sudo'\n"
		apt install -y sudo > /dev/null 2>&1
	fi
}


function	ft_ssh()
{	
	arg1="dpkg -l" arg2=" openssh-server " checkFile	
	if [ $? == "0" ]; then
		echo -e "[!] 'openssh-server'\t\tOK!\n"
	else	
		echo -e "[!] Instalando 'openssh-server'\n"
		apt install -y openssh-server > /dev/null 2>&1
	fi
}

function	ft_ufw()
{
	arg1="dpkg -l" arg2=" ufw " checkFile	
	if [ $? == "0" ]; then
		echo -e "[!] 'ufw'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'ufw'\n"
		apt install -y ufw > /dev/null 2>&1

		arg1="ufw status" arg2="inactive" checkFile
		if [ $? == "0" ]; then
			ufw enable
		fi

		arg1="ufw status" arg2="4242" checkFile
		if [ $? == "0" ]; then
			echo -e "[!] Puerto 4242\t\tALLOW\n"
		else
			ufw allow 4242 > /dev/null
		fi
	fi
}

function	ft_cron()
{
		if [ $? == "0" ]; then
			echo -e "[!] '$pack'\t\t\tOK!\n"
		else
			echo -e "[!] Installing '$pack'\n"
			apt install cron -y > /dev/null 2>&1
		fi

		test -f | cat /var/spool/cron/crontabs/root > /dev/null 2>&1
		if [ $? != "0" ]; then
			echo "***** cronpath.sh" > /var/spool/cron/crontabs/root
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
	ft_sudo
	ft_ssh
	ft_ufw
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
			ft_install
		else
			helpPanel
		fi
	fi


else
	echo "no soy root"
fi