#!/bin/bash

trap ctrl_c INT

function	ctrl_c()
{
	echo "Saliendo"
}

function	ft_sudo()
{
	test -f | dpkg -l | grep sudo > install.log
	if [ $? == "0" ]; then
		echo -e "[!] 'sudo'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'sudo'\n"
		sleep 1
		apt install -y sudo
	fi
}


function	ft_ssh()
{
	test -f | dpkg -l | grep openssh-server > install.log
	if [ $? == "0" ]; then
		echo -e "[!] 'openssh-server'\t\tOK!\n"
	else	
		echo -e "[!] Instalando 'openssh-server'\n"
		sleep 1
		apt install -y openssh-server
	fi
}

function	ft_ufw()
{
	test -f | dpkg -l | grep ufw >> install.log
	if [ $? == "0" ]; then
		echo -e "[!] 'ufw'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'ufw'\n"
		sleep 1
		apt install -y ufw
		
		test -f | systemctl status ufw | grep "Active: inactive"
		if [ $? == "0" ]; then
			systemctl start ufw
		fi
		
		test -f | ufw status | grep "4242"
		if [ $? == "0"]; then
			echo -e "[!] Puerto 4242\t\tALLOW\n"
		else
			ufw allow 4242
		fi
	fi
}

function	ft_help()
{
	echo "muestra panel de ayuda"
	echo -e "usa -f install"
}

function	ft_install()
{	
	sleep 0.5
	ft_sudo
	sleep 0.5
	ft_ssh
	sleep 0.5
	ft_ufw
}



# Main function

cat banner.txt

if [ "$(id -u)" == "0" ]; then

	declare -i counter="0";
	while getopts ":f:" arg; do
		case $arg in
			f) funcion=$OPTARG; let counter+=1
		esac
	done

	if [ $counter -ne 1 ]; then
		ft_help
	else
		if [ $funcion == "install" ]; then
			ft_install
		else
			ft_help
		fi
	fi

else
	echo "no soy root"
fi
	


