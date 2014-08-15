# Class: mysql::server
#
# Manages mysql.
# Include it to install and run mysql with default settings
#
# Usage:
# include mysql
import "redhat/*.pp"
import "sun/*.pp"

class mysql::server inherits mysql {
 @user{"mysql":
	ensure => present,
	uid => "27",
	gid => "mysql",
	home => "/var/lib/mysql",
	shell => "/bin/bash",
	tag => "mysql", }


  User <| tag == "mysql" |>

   #package{"rails": provider => gem, ensure => "2.2.2"}
   package{"ruby-mysql": ensure => latest}

   file { "/etc/my.cnf":
        content => template("mysql/my.cnf.erb"),
        owner => "root", group => "root", mode => "0644",
        require => [User["mysql"]], }

   file { "/var/log/mysql":
        ensure => directory,
        owner => "mysql", group => "mysql", mode => "0775",
        require => [File["/etc/my.cnf"], User["mysql"]], }

   file {"/var/run/mysqld/":
        ensure => directory,
        owner => "mysql", group => "mysql", mode => "0755",
        require => [File["/etc/my.cnf"], User["mysql"]], }

   file {"/var/lib/mysql":
	      ensure => directory,
	      owner => "mysql", group => "mysql", mode => "0775",
        require => [File["/etc/my.cnf"], User["mysql"]], }

   file {"/var/lib/mysql/mysql":
	      ensure => directory, }

}#end of mysql::server class
