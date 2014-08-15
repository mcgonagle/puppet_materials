# Class: ocsinventory::server
#
# This module manages ocsinventory::server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class ocsinventory::server {
  include ocsinventory::install, ocsinventory::config

  package{"ocsinventory-reports": ensure => installed }
  package{"ocsinventory-server": ensure => installed }
  package{"ocsinventory": ensure => installed }
  package{"perl-Net-IP": ensure => installed }

#have to create the ocsweb database and the ocs/ocs username and password
#as well as visit the install path to generate the ocsweb tables
#mysql -u root -e 'create database ocsweb;'
#mysql -u root -e 'grant all on ocsweb.* to ocs@'localhost' identified by 'ocs'; flush privileges;'
#http://${servername}/ocsreports/install.php


}
