# Class: mysql::config
#
# This module manages mysql::config
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
class mysql::config {
  file{"/etc/my.cnf":
    content => template("mysql/my.cnf.erb"),
    owner => "root", group => "root", mode => "0644",
    require => Class["mysql::install"], }

}
