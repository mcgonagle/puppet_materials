# Class: ocsinventory
#
# Manages ocsinventory software 
# Include it to install and run ocsinventory with default settings
#
# Usage:
# include ocsinventory


import "classes/*.pp"
#import "defines/*.pp"

class ocsinventory {
    package{"ocsinventory-agent": ensure => latest}

    file{"/etc/sysconfig/ocsinventory-agent":
      source => "puppet:///modules/ocsinventory/ocsinventory-agent",
      owner => "root", group => "root", mode => "0644",
      require => Package["ocsinventory-agent"], }

   file{"/etc/ocsinventory/ocsinventory-agent.cfg":
      content => template("ocsinventory/ocsinventory-agent.cfg.erb"),
      #source => "puppet:///modules/ocsinventory/ocsinventory-agent.conf",
      owner => "root", group => "root", mode => "0644",
      require => Package["ocsinventory-agent"], }

#have to create the ocsweb database and the ocs/ocs username and password
#as well as visit the install path to generate the ocsweb tables
#mysql -u root -e 'create database ocsweb;'
#mysql -u root -e 'grant all on ocsweb.* to ocs@'localhost' identified by 'ocs'; flush privileges;'
#http://${servername}/ocsreports/install.php


}#end of class ocsinventory
