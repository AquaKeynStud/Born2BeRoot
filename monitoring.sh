#!/bin/bash

# Architecture
arch=$(uname --all)

# CPU Physiques
cpup=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

# CPU virtuels
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
total_ram=$(free --mega | grep "Mem:" | awk '{print $2}')
used_ram=$(free --mega | awk 'NR==2 {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}')

# DISQUES
used_space=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
available_space=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result += $2} END {printf ("%.0fGb\n"), memory_result/1024}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3; total += $2} END {printf("(%.0f%%)\n"), use/total*100}')

# CPU LOAD
cpu_usage=$(vmstat 1 4 | tail -1 | awk '{printf ("%.1f%%\n"), 100 - $15}')

# DERNIER LANCEMENT
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm_status=$( if [ $(lsblk | grep "lvm" | wc -l) == 0 ]; then
	echo Actif;
else
	echo Inactif;
fi )

# CONNECTIONS TCP
tcp_ct=$(ss | grep tcp | wc -l)

# LOG USER
user_ct=$(users | wc -w)

# INTERNET
ip_adress=$(hostname -I)
mac_adress=$(ip link | grep link/ether | awk '{print $2}')

# SUDO
sudo_ct=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $arch
		Processeurs physiques: $cpup
		Processeurs virtuels: $cpuv
		Mémoire vive (RAM): $used_ram/${total_ram}MB	($ram_percent)
		Espace disque: $used_space/$available_space	($disk_percent)
		Utilisation des processeurs: $cpu_usage
		Dernier lancement: $last_boot
		Statut LVM: $lvm_status
		Nombre de connexions actives: $tcp_ct connections établies
		Nombre d'utilisateurs utilisant le server: $user_ct
		Adresse du serveur: ip: $ip_adress ($mac_adress)
		Nombre de commandes executées avec sudo: $sudo_ct commandes"