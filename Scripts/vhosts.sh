#!/bin/bash
# This script is used for create virtual hosts on Debian
# Created by dporta97 from http://dporta.es
#   PARAMETERS
#
# $usr          - User
# $dir          - directory of web files
# $servn        - domain.
# $serv        - domain without tld
# $cname        - cname of webserver

#Colours
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
cyan="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

# Check if you execute the script as root user
if [ "$(whoami)" != 'root' ]; then
echo -e "${red}You have to execute this script as root user${end}"
exit 1;
fi

#Set variables
read -p "Enter the domain : " servn
read -p "Enter a CNAME: " cname

srv="${servn%.*}"
dir="/var/www/${srv%.*}/"
usr="${srv%.*}"

# This will check if directory already exists
if ! mkdir -p $dir$cname_$servn; then
echo -e "${yellow}Web directory already Exist !${end}"
else
echo -e "${green}Web directory created sucessfully !${end}"
fi

#Create user and group
adduser $usr
addgroup $usr
echo -e "${green}User and group created sucessfully!${end}"

chown -R $usr:$usr $dir
chmod -R '755' $dir
mkdir $dir/logs/

#Check if alias is none
alias=$cname.$servn
if [[ "${cname}" == "" ]]; then
alias=$servn
fi

#Create a virtual host
echo "#### $servn
<VirtualHost *:80>
ServerName $servn
ServerAlias $alias
DocumentRoot $dir
<Directory $dir>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
Require all granted
</Directory>
</VirtualHost>" > /etc/apache2/sites-available/$servn.conf
if ! echo -e /etc/apache2/sites-available/$servn.conf; then
echo -e " ${red}Virtual host wasn't created !${end}"
else
echo "${green}Virtual host created !${end}"
a2ensite $servn.conf
fi


echo "Do you want to restart the server [y/n]? "
read q
if [[ "${q}" == "yes" ]] || [[ "${q}" == "y" ]]; then
systemctl restart apache2
fi

echo "======================================"
echo -e " ${green}All works done!The website is available at http://$servn${end}"
echo "======================================"
