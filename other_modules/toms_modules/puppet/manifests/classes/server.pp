# Class: puppet::server
#
# This class installs a puppet server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  include puppet::server
#
class puppet::server inherits puppet {
  package{"puppet-server": ensure => latest}
  include augeas
  
  include cobbler_server
  include passenger
  include puppet-dashboard
  include mysql::server

 File["/etc/puppet/puppet.conf"]{ source => undef }

 file{"/etc/puppet/manifests":
  ensure => directory,
  owner => "root", group => "root", mode => "0755",
  require => [Package["puppet-server"],File["/etc/puppet/puppet.conf"]] }

 #file{"/etc/puppet/manifests/site.pp":
 # source => "puppet:///modules/puppet/site.pp",
 # owner => "root", group => "root", mode => "0644",
 # require => File["/etc/puppet/manifests"], }

 #file{"/var/tmp/puppet_db_check":
 # content => 'select distinct(table_schema) from tables where table_schema = "puppet";',
 # owner => "root", group => "root", mode => "0755",
 # require => Package["puppet"], }

 #file{"/var/tmp/create_exported_restype_title_index":
 # content => 'create index exported_restype_title on resources (exported, restype, title(50));',
 # owner => "root", group => "root", mode => "0755",
 # require => Package["puppet"], }

 #file{"/var/tmp/puppet_exported_restype_title_index_check":
 # content => 'select distinct(index_name) from statistics where index_name = "exported_restype_title";',
 # owner => "root", group => "root", mode => "0755",
 # require => Package["puppet"], }

 #exec{"mysql -u root -e 'create database puppet;'":
 # path => [ "/bin", "/sbin", "/usr/bin" ],
 # unless => 'mysql -u root information_schema < /var/tmp/puppet_db_check',
 # require => [ Service["mysqld"], File["/var/tmp/puppet_db_check"]], }

 #exec{"mysql -u root puppet puppet < /var/tmp/create_exported_restype_title_index":
 # path => [ "/bin", "/sbin", "/usr/bin" ],
 # unless => 'mysql -u root information_schema < /var/tmp/puppet_exported_restype_title_index_check',
 # require => [ Service["mysqld"], File["/var/tmp/create_exported_restype_title_index"], File["/var/tmp/puppet_exported_restype_title_index_check"]], }
}#end of class puppet::server
