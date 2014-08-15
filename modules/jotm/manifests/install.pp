# Class: jotm::install
#
# This module manages jotm::install
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
class jotm::install {
  require tomcat

   file {"/opt/tomcat/lib/":
       source => "puppet:///modules/jotm/lib/",
       owner => "root", group => "root", mode => "0644",
       ensure => present,
       recurse => true, }

}
