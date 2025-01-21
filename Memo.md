
# **<u><p style="text-align:center; ">Mémo Born2BeRoot</p></u>**

## Passwords :

- Cryptage : ```Arocca42Encrypt!```
- root : ```Born2Beborn!```
- arocca : ```Born2Beroot!```

#### Instalation de Debian

>> Se renseigner sur <span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://fr.wikipedia.org/wiki/GNU_GRUB">GRUB boot</a></u></span> (amorçage)

## Commandes :

>> Se renseigner sur apt / aptitude (différences/utilité...)

> <u>sudo</u> = **s**ubstitute **u**ser **do**
> <u>getent</u> = **get** **ent**ities (from Name Service Switch librairies)
> <u>apt</u> = **A**dvanced **P**ackage **T**ool
 
1. ***Machine virtuelle*** :
   - `su`
   - `sudo reboot`
   - `hostnamectl set-hostname <new_hostname>` - <span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://www.hostinger.fr/tutoriels/changer-nom-hote-linux#Comment_changer_le_nom_dhote_de_facon_permanente_sous_Linux">hostnamectl</a></u></span>
2. ***Installations / Updates*** :
   - `apt install sudo`
   - `sudo apt update`
   - `sudo apt install openssh-server`
   - `sudo apt install ufw`
   - `sudo apt install libpam-pwquality`
3. ***Informations*** :
   - `sudo -V` = vérifier l'installation de sudo
   - `sudo service ssh status`
   - `sudo chage -l <username>` = informations du mdp d'un user
   - `passwd -S <user>` - <span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://www.it-connect.fr/changer-le-mot-de-passe-dun-utilisateur-avec-passwd%EF%BB%BF/#I_Presentation">passwd</a></u></span>
4. ***Utilisateurs*** :
   - `sudo adduser <user>`
   - `sudo addgroup <group>`
   - `sudo adduser <user> <group>`
   - `getent group <groupname>`
   - `sudo chage -M 30 -m 2 -W 7 <username>` = changer les valeurs de politique de mdp
5. ***Firewall*** :
   - `sudo ufw enable`
   - `sudo ufw allow 4242`
   - `sudo ufw delete allow 4242`
   - `sudo ufw status verbose`
6. ***SSH*** :
   - `ssh <user>@localhost -p 4242` - (ou ip a la place de `localhost`  et port apres -p)
7. ***Paths*** :
   - `/etc/group/`
   - `/etc/ssh/sshd_config`
   - `/etc/ssh/ssh_config`
   - `/etc/sudoers.d/sudo_config`
   - `/var/log/sudo`
   - `/etc/login.defs`
   - `/etc/pam.d/common-password`

## SSH :

>> <u>SSH</u> : **S**ecure  **Sh**ell - Permet à un administrateur de se connecter à un server à distance. Fonctionne avec un modèle client-serveur. Est crypté.

#### Dans le fichier de config côté server

- Changer le port
- Changer le PermitRootLogin (Permet ou non à Root de se connecter, par défaut à *prohibit-password*)

#### Dans le fichier de config côté client

- Changer le port

## UFW

>> firewall : **<a href="https://doc.ubuntu-fr.org/ufw">Pare feu Netfilter UFW</a>**

## Politique stricte de sudo

##### Créer le fichier de configuration de sudo :

- créer le fichier `sudo_config` dans répertoire `/etc/sudoers.d/` 
- définir la politique stricte de sudo comme dans le sujet :
  - `Defaults  passwd_tries=3` - Nombres d'essais pour le mdp sudo
  - `Defaults  badpass_message="Message d'erreur"` - Message d'erreur en cas de mauvais mdp
  - `Defaults  logfile="/var/log/sudo/sudo_config"` - Chemin où les logs de sudo seront enregistrés
  - `Defaults  log_input, log_output` - Ce qui va être log
  - `Defaults  iolog_dir="/var/log/sudo"` - Ce qui va être log
  - `Defaults  requiretty` - Oblige l'utilisation avec un **<span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://www.shell-tips.com/linux/sudo-sorry-you-must-have-a-tty-to-run-sudo/#gsc.tab=0">TTY</a></u></span>**
  - `Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"` - Chemin exclu de sudo

##### Créer le dossier de logs de sudo (pour les logs input et output)

- créer le répertoire `sudo` dans le répertoire `/var/log/`

## Politique de mot de passe fort

##### Changer les options de base dans le fichier `/etc/login.defs`

- `PASS_MAX_DAYS = 30` - Jours avant expirations du mdp
- `PASS_MIN_DAYS = 2`  - Minimums de jours avant de pouvoir modifier un mdp
- `PASS_WARN_AGE = 7`  - Avertit l'utilisateur 7 jours avant que son mdp n'expire

##### Installer <span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://debian-facile.org/doc:securite:passwd:libpam-pwquality">libpam-pwquality</a></u></span>

- Aller dans le fichier `/etc/pam.d/common-password`
- Aller à la fin de la ligne où figure la mention de la bibliothèque partagée `pam_pwquality.so` (le paramètre `retry=3` est initialisé par défaut. Mettre les autres arguments à la suite en les séparant par des espaces).
- Ajouter les options suivantes :
	- `minlen = 10` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- taille minimum du mot de passe
	- `ucredit=-1` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Nombre de majuscules exigées en négatif
	- `lcredit=-1` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Nombre de minuscules exigées en négatif
	- `dcredit=-1` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Nombre de chiffres exigés en négatif
	- `maxrepeat=3` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Maximum d'occurences d'un caractère
	- `usercheck=1` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Vérifie que le username ne soit pas contenu dans le mdp (avec username > 3 caractères)
	- `reject_username` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Vérifie que le mdp soit différent de l'username
	- `diftok=7` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Nombre de caractères ne devant pas être présents dans l'ancien mdp
	- `enforce_for_root` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	- Cela effectue les vérifications pour Root également (sauf diftok : root ne nécessite pas d'ancien mdp)

>>> Autres sources pour les flags : <span style="color:rgb(50,128,255)"><u><a style="color:rgb(50,128,255)" href="https://manpages.debian.org/testing/libpam-pwquality/pam_pwquality.8.en.html">manpages.debian.org</u></a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u><a style="color:rgb(50,128,255)" href="https://www.linux-magazine.com/Issues/2020/239/Charly-s-Column-pwquality">linux-magazine.org</u></a></span>

## Script

- Aller dans `/usr/local/bin` - (Dossier recommandé pour les exécutables non contenus dans les librairies)
- créer avec `touch` le fichier `monitoring.sh`
- donner les permissions au fichier avec `chmod 777 monitoring.sh`

##### Commandes :

```bash
	uname -a

	grep "physical id" /proc/cpuinfo | sort -u | wc -l

	grep "processor" /proc/cpuinfo | wc -l

	free --mega | grep "Mem:" | awk '{print $2}'
	free --mega | awk 'NR==2 {print $3}'
	free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}'

	df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}'
	df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result += $2} END {printf ("%.0fGb\n"), memory_result/1024}'
	df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3; total += $2} END {printf("(%.0f%%)\n"), use/total*100}'

	vmstat 1 4 | tail -1 | awk '{printf ("%.1f%%\n"), 100 - $15}'

	who -b | awk '$1 == "system" {print $3 " " $4}'

	if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then
		echo Actif;
	else
		echo Inactif;
	fi

	ss | grep tcp | wc -l

	users | wc -w

	hostname -I
	ip link | grep link/ether | awk '{print $2}'

	journalctl -q _COMM=sudo | grep COMMAND | wc -l
```

##### Manuels :

Cliquez sur les commandes pour accéder aux manuels (si plusieurs man, ajout des autres commandes après)

- Commandes :
  - <a href="https://www.digitalocean.com/community/tutorials/grep-command-in-linux-unix">`grep`</a>
  - <a href="https://www.malekal.com/la-commande-sort-linux-utilisations-et-exemples/">`sort`</a>
  - <a href="https://fr.wikipedia.org/wiki/Wc_(Unix)#:~:text=wc%20(en%20r%C3%A9f%C3%A9rence%20aux%20termes,nom%20l'indique)%20et%20le">`wc`</a>
  - <a href="https://www.turing.com/kb/how-to-use-the-linux-free-command#what-is-the-'free'-command?">`free`</a>
  - <a href="https://connect.ed-diamond.com/GNU-Linux-Magazine/glmf-131/awk-le-langage-script-de-reference-pour-le-traitement-de-fichiers">`awk`</a>
  - <a href="https://fr.wikipedia.org/wiki/Df_(Unix)#:~:text=df%20(abr%C3%A9viation%20de%20disk%20free,en)%20ou%20en%20utilisant%20statfs.">`df`</a>
  - <a href="https://www.linuxtricks.fr/wiki/vmstat-surveillance-systeme-en-temps-reel">`vmstat`</a>
  - <a href="https://www.techno-science.net/glossaire-definition/Tail-Unix.html">`tail`</a>
  - <a href="https://fr.wikipedia.org/wiki/Who_(Unix)">`who`</a>
  - <a href="https://debian-facile.org/doc:systeme:lsblk">`lsblk`</a> - (-gt dans la même commande signifie "grater than"; soit "plus grand que")
  - <a href="https://fr.wikipedia.org/wiki/Echo_(Unix)#:~:text=echo%20est%20une%20commande%20UNIX,le%20terminal%20(sortie%20standard).">`echo`</a>
  - <a href="https://www.linuxtricks.fr/wiki/ss-informations-sur-les-connexions-tcp-udp-et-sockets-reseau-remplace-netstat#:~:text=La%20commande%20ss%20(pour%20Socket,sur%20toutes%20les%20distributions%20Linux.">`ss`</a>
  - <a href="https://www.ibm.com/docs/fr/aix/7.3?topic=u-users-command">`users`</a>
  - <a href="https://www.man-linux-magique.net/man1/hostname.html">`hostname`</a>
  - <a href="https://www.linuxtricks.fr/wiki/la-commande-ip-reseau-interfaces-routage-table-arp">`ip`</a>
  - <a href="https://just-sudo-it.be/journalctl-maitrisez-le-systeme-de-journalisation-de-linux/">`journalctl`</a>
- Fichiers :
  - <a href="https://blog.shevarezo.fr/post/2017/09/01/6-commandes-linux-recuperer-informations-cpu-processeur">`/proc/cpuinfo`</a>

#### Script :

```bash
#!/bin/bash

# Architecture
arch=$(uname --all)

# CPU Physiques
cpup=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

# CPU virtuels
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
total_ram=$(free --mega | grep "Mem:" | awk {print $2})
used_ram=$(free --mega | awk NR==2 {print $3})
ram_percent=$(free --mega | awk $1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)})

# DISQUES
used_space=$(df -m | grep "/dev/" | grep -v "/boot" | awk {memory_use += $3} END {print memory_use})
available_space=$(df -m | grep "/dev/" | grep -v "/boot" | awk {memory_result += $2} END {printf ("%.0fGb\n"), memory_result/1024})
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk {use += $3; total += $2} END {printf("(%.0f%%)\n"), use/total*100})

# CPU LOAD
cpu_usage=$(vmstat 1 4 | tail -1 | awk '{printf ("%.1f%%\n"), 100 - $15}')

# DERNIER LANCEMENT
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm_status=$( if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then
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
mac_adress=$(ip link | grep link/ether | awk {print $2})

# SUDO
sudo_ct=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "          #Architecture: $arch

                #Processeurs physiques: $cpup
                #Processeurs virtuels: $cpuv
                #Utilisation des processeurs: $cpu_usage

                #Mémoire vive (RAM): $used_ram/${total_ram}MB   $ram_percent

                #Espace disque: $used_space/$available_space    $disk_percent
                #Status LVM: $lvm_status

                #Dernier lancement: $last_boot

                #Nombre de connexions actives: $tcp_ct connections établies
                #Adresse du serveur: ip: $ip_adress ($mac_adress)

                #Nombre d'utilisateurs utilisant le server: $user_ct

                #Nombre de commandes executées avec sudo: $sudo_ct commandes"
```