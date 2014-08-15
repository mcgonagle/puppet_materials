class ocsinventory::server inherits ocsinventory {
  package{"ocsinventory-reports": ensure => latest }
  package{"ocsinventory-server": ensure => latest }
  package{"ocsinventory": ensure => latest }
  package{"perl-Net-IP": ensure => latest }

  include httpd
  include pear
  include php::devel
  include mysql::server

 #file{"/var/tmp/ocsweb_db_check":
  	#content => 'select distinct(table_schema) from tables where table_schema = "ocsweb";',
  	#owner => "root", group => "root", mode => "0644",
  	#require => Package["ocsinventory-server"], }

  #exec{"mysql -u root -e 'create database ocsweb;'":
  	#path => [ "/bin", "/sbin", "/usr/bin" ],
  	#unless => 'mysql -u root information_schema < /var/tmp/ocsweb_db_check',
  	#require => [File["/var/tmp/ocsweb_db_check"]], }
 
  #file{"/var/tmp/ocs_grant_user":
	#content => 'GRANT ALL on ocsweb.* TO "ocs"@"localhost" IDENTIFIED BY "ocs";',
	#owner => "root", group => "root", mode => "0644",
	#require => Package["ocsinventory-server"], }
  
  #exec{"mysql -u root < /var/tmp/ocs_grant_user":
  	#path => [ "/bin", "/sbin", "/usr/bin" ],
  	#unless => '/usr/bin/mysql --user=ocs --password=ocs ocsweb', 
  	#require => [Exec["mysql -u root -e 'create database ocsweb;'"],File["/var/tmp/ocs_grant_user"]] } 
}#end of class ocsinventory::server
