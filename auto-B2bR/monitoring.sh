#!/bin/bash

#kernel
kernel="$(hostnamectl | grep "Kernel" | cut -c 21-)"

#so
OS="$(hostnamectl | grep "Operating System" | cut -c 21-)"

#Arquitectura
Architecture="$(hostnamectl | grep "Architecture" | cut -c 21-)"

#CPU
CPU_physical="$(nproc)"

#vCPU
CPU_virtual="$(cat /proc/cpuinfo | grep "processor" | wc -l)"

#Uso de Memoria RAM
Memory_usage="$(free --mega | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')"

#Uso de Disco
Disk_usage="$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')"

#Uso CPU
CPU_load="$(vmstat 1 2 | tail -1 | awk '{print 100-$15 "%"}')"

#Fecha de inicio
Last_boot="$(who -b | awk '{print $3" "$4" "$5}')"

#LVM
LVM="$(lsblk | grep lvm | awk '{if ($1) {print "Si";exit;} else {print "No"}}')"

#Conexiones TCP
TCP_connexions="$(netstat -an | grep ESTABLISHED |  wc -l)"

#Usuarios conectados
User_log="$(who | cut -d " " -f 1 | sort -u | wc -l)"

#Direccion IP/MAC
IP="$(hostname -I)"
MAC="$(ip a | grep link/ether | awk '{print $2}')"

#Sudo
sudo="$(cat /var/log/sudo/sudo.log | grep "COMMAND" | wc -l)"

#main script
wall	"\nArchitecture: ${kernel} ${OS} ${Architecture}
CPU: ${CPU_physical}
vCPU: ${CPU_virtual}
Memory Usage: ${Memory_usage}
Disk Usage: ${Disk_usage}
CPU Load: ${Last_boot}
LVM: ${LVM}
Connexions TCP: ${TCP_connexions}
User Log: ${User_log}
Network IP/MAC: ${IP} (${MAC})
Sudo: ${sudo} cmd"
