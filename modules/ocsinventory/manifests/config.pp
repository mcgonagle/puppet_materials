# Class: ocsinventory::config
#
# This module manages ocsinventory::config
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
class ocsinventory::config {

    file{"/etc/sysconfig/ocsinventory-agent":
      source => "puppet:///modules/ocsinventory/ocsinventory-agent",
      owner => "root", group => "root", mode => "0644",
      require => Class["ocsinventory::install"], }

   file{"/etc/ocsinventory/ocsinventory-agent.cfg":
      content => template("ocsinventory/ocsinventory-agent.cfg.erb"),
      #source => "puppet:///modules/ocsinventory/ocsinventory-agent.conf",
      owner => "root", group => "root", mode => "0644",
      require => Class["ocsinventory::install"], }


}
