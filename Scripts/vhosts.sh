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

# Check if you execute the script as root user
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
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
echo "Web directory already Exist !"
else
echo "Web directory created sucessfully !"
fi

#Create user and group
adduser $usr
addgroup $usr
echo "User and group created sucessfully!"

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
echo "Virtual host wasn't created !"
else
echo "Virtual host created !"
a2ensite $servn.conf
fi


echo "Do you want to restart the server [y/n]? "
read q
if [[ "${q}" == "yes" ]] || [[ "${q}" == "y" ]]; then
systemctl restart apache2
fi

echo "======================================"
echo "All works done!The website is available at http://$servn"
echo "======================================"
