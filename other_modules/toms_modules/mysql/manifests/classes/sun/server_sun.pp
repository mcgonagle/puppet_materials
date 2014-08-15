# Class: mysql::server::sun
#
# Manages mysql.
# Include it to install and run mysql with default settings
#
# Usage:
# include mysql::server::sun

import "my_cnf/*.pp"
class mysql::server::sun inherits mysql::server {

   yumrepo{"mysql-enterprise":
        name => "mysql-enterprise",
        baseurl => "http://cobitpd01.wal.manhunt.net:80/cobbler/repo_mirror/mysql-enterprise",
        enabled => "1",
        gpgcheck => "0",
        metadata_expire => "1",
        priority => "99", }

    package{"MySQL-server-enterprise-gpl": ensure => latest}
    package{"MySQL-client-enterprise-gpl": ensure => latest}
    package{"perl-DBD-MySQL": ensure => latest, }

   file {"/var/lib/mysql/data":
	ensure => directory,
	owner => "mysql", group => "mysql", mode => "0775",
	require => Package["MySQL-server-enterprise-gpl"], }

  #service { "mysql":
  #      ensure => running,
  #      enable => true,
  #      hasrestart => true,
  #      hasstatus => true,
  #      require => [File["/var/log/mysql"], File["/var/run/mysqld"], File["/var/lib/mysql/data"]],
  #      subscribe => File["/etc/my.cnf"], }

  monit::monitd{"mysqld":
        pid_file => "/var/run/mysqld/mysqld.pid",
        init_script => "/etc/init.d/mysql", }

}#end of mysql::server::sun class
