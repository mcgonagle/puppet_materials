# Class: mysql::server::redhat
#
# Manages mysql.
# Include it to install and run mysql with default settings
#
# Usage:
# include mysql::server::redhat
import "my_cnf/*.pp"
class mysql::server::redhat inherits mysql::server {
 package{"mysql-server": ensure => latest}
 package{"mysql-devel": ensure => latest}
 package{"mysql": ensure => latest }


 service { "mysqld":
   ensure => running,
   enable => true,
   require => [File["/etc/my.cnf"], Package["mysql-server"]], }

#munin monitoring
 #include munin::plugin::mysql
 monit::monitd{"mysqld":
        pid_file => "/var/run/mysqld/mysqld.pid",
        init_script => "/etc/init.d/mysqld", }
}#end of mysql::server class
