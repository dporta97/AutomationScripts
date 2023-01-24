#!/bin/bash

#Colours
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
cyan="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"


read -p "Enter domain nane : " domain
read -sp "Enter pass fot mysql root user : " pass

name="${domain%.*}"
newpass=$(openssl rand -base64 15)

echo -e "${yellow} Let's go to create database ${end}"

mysql -u root -p"$pass" -e "CREATE DATABASE $name;"
mysql -u root -p"$pass" -e "GRANT ALL PRIVILEGES ON $name.* TO '$name'@'%' IDENTIFIED BY '$newpass';"

echo -e "${green} DB created ${end}"

read -p "Do you want to import sql in db? (y/n)" yn

case $yn in
	y )
		echo -e "${yellow} Okey, let's go ${end}"
		read -p "Give me the path to sql file " sql
	       	mysql -u "$name" -p"$newpass" "$name" < "$sql"
		echo -e "${reen} SQL imported sucesfully ${end}"
		exit;;
	no )
		echo -e "${green} Okey, se you soon :) ${end}"
		exit;;
	* ) 
		echo -e "${red} You don't choose the correct opcion ${end}";
		exit 1;;
esac


