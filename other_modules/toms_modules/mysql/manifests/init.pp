# Class: mysql
#
# Manages mysql.
# Include it to install and run mysql with default settings
#
# Usage:
# include mysql


import "defines/*.pp"
import "classes/*.pp"
class mysql {
 require mysql::params
 include rsync
 include mysql-backup
 include mysql::monitor

 file { "/etc/profile.d/mysql.sh":
        content => template("mysql/profile.d/mysql.sh.erb"),
        owner => "root", group => "root", mode => "0755", }

}#end of mysql class
