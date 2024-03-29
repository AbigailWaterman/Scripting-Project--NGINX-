#!/bin/bash
#title           :nginx_install_centOS.sh
#description     :This script will install NginX on an install of CentOS version 6.
#author          :Abigail Waterman
#date            :06/14/2014
#version         :0.2
#usage           :bash nginx_install_centOS.sh OR ./nginx_install_centOS.sh
#==============================================================================


NGINX_Directory="/tmp/nginx"
NGINX_Web_store="http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm"


        check_system() {

# This will check to ensure that the current user has root privileges

if [[ $EUID -ne 0 ]] ;
	then
	echo "Error: This script must be run with root access to install nginx."
	exit 1
fi

# This section will check the current operating system to ensure that it is CentOS 6. If it is an alternate flavor or version, it will exit.

echo "Checking your flavor and version of Linux"

FLAVOR=$(cat /etc/*release | grep -i "centos" | grep -i "release 6" | wc -l)

if [ $FLAVOR -gt 0 ]

        then
echo "You are running CentOS version 6. Now Proceeding to download NGINX package."

                download
        else
                echo "This installation of Linux is not CentOS version 6. Please find an alternate installation script that is appropriate for your system."

	fi
                exit 1;
        }

        download() {
# This subroutine will download the appropriate repository of NGINX to a /tmp subdirectory

rm -Rf $NGINX_Directory/*

if [ ! -d $NGINX_Directory ]

	then

	mkdir $NGINX_Directory

	fi;

cd $NGINX_Directory
	#downloading current RPM
wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	#registering RPM
rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
	#proceeding to yum installer subroutine
yum_install;

        }

        yum_install() {
	#This subroutine will 
yum -y install nginx;
configure;
                }

	configure() {
#Change default listening port to 8888
sed -i "2s/.*/      listen       8888;/" /etc/nginx/conf.d/default.conf
start_nginx;
		}

	start_nginx() {
service nginx start
verify;
		}

	verify() {
netstat -anp | grep 8888;
        }

check_system

