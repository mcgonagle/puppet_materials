# Class: multi_mysql
#
# Manages multi_mysql software 
# Include it to install and run multi_mysql with default settings
#
# Usage:
# include multi_mysql


import "classes/*.pp"
#import "defines/*.pp"

class multi_mysql {

 #@user{"mysql":
 #       ensure => present,
 #       uid => "27",
 #       gid => "mysql",
 #       home => "/var/lib/mysql",
 #       shell => "/bin/bash",
 #	tag => "mysql", }
 # User <| tag == "mysql" |> 

 file{"/var/lib/multi_mysql":
        ensure => directory,
        owner => "mysql", group => "mysql", mode => "0755", }

}#end of class multi_mysql
