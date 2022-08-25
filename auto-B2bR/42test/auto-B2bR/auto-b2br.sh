#!/bin/bash

trap ctrl_c INT

function	ctrl_c()
{
	echo "Saliendo"
}

function	ft_bool()
{	
	test -f | dpkg -l | grep $pack > /dev/null 2>&1
}

function	ft_verify()
{
	ft_bool
	if [ $? == "0" ]; then
		echo -e "[!] Verify '$pack'\t\tOK!\n"
	else
		
		echo -e "[!] Verify '$pack'\t\tKO!\n"
	fi
}

function	ft_sudo()
{
	pack=sudo	
	ft_bool
	if [ $? == "0" ]; then
		echo -e "[!] 'sudo'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'sudo'\n"
		sleep 1
		apt install -y sudo > /dev/null 2>&1
	fi
}


function	ft_ssh()
{	
	pack="openssh-server"
	ft_bool		
	if [ $? == "0" ]; then
		echo -e "[!] 'openssh-server'\t\tOK!\n"
	else	
		echo -e "[!] Instalando 'openssh-server'\n"
		sleep 1
		apt install -y openssh-server > /dev/null 2>&1
	fi
}

function	ft_ufw()
{
	pack="ufw"
	ft_bool
	if [ $? == "0" ]; then
		echo -e "[!] 'ufw'\t\t\tOK!\n"
	else
		echo -e "[!] Instalando 'ufw'\n"
		sleep 1
		apt install -y ufw > /dev/null 2>&1
		
		test -f | systemctl status ufw | grep "Active: inactive"
		if [ $? == "0" ]; then
			systemctl start ufw > /dev/null
		fi
		
		test -f | ufw status | grep "4242"
		if [ $? == "0" ]; then
			echo -e "[!] Puerto 4242\t\tALLOW\n"
		else
			ufw allow 4242 > /dev/null
		fi
	fi
}

function	ft_cron()
{
		pack="cron"
		ft_bool
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
	ft_cron
}



# Main function

cat banner.txt

if [ "$(id -u)" == "0" ]; then
	
	install="0"
	verify="0"
	declare -i counter="0";
	while getopts ":i:v:" arg; do
		case $arg in
			i) install=$OPTARG; let counter+=1 ;;
			v) verify=$OPTARG; let counter+=1 ;;
		esac
	done

	if [ $counter -ne 1 ]; then
		ft_help
	else
		if [ $install == "all" ]; then
			ft_install
		elif [ "$verify" == "ssh" ]; then
			pack=openssh-server
			ft_verify
		else
			ft_help
		fi
	fi


else
	echo "no soy root"
fi
	


