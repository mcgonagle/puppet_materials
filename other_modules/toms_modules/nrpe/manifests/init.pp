import "defines/*.pp"
class nrpe {
 include nagios
 include product

 package { "nrpe": ensure => latest }
 package { "nagios-plugins-nrpe": ensure => latest }
 package { "nagios-plugins": ensure => latest }
 #package { "nagios-plugins-all": ensure => latest }
 
 file { "/etc/nagios/nrpe.cfg":
  content => template("nagios/nrpe.cfg.erb"),
  owner => "root", group => "nrpe", mode => "0644", 
  require => Package["nrpe"],}

 file {"/etc/nagios/nrpe.d":
	ensure => directory,
	owner => "root", group => "nrpe", mode => "0775", 
	require => [Package["nrpe"], File["/etc/nagios/nrpe.cfg"]],}

 nagmon::service { "nrpe":
   enable => true,
   ensure => running,
   pid_file => "/var/run/nrpe/nrpe.pid",
   init_script => "/etc/init.d/nrpe", 
   warn => "1:3",
   critical => "1:3",
   nrpe_parameter => "-C nrpe",  
   require => [ Package["nrpe"], 
                Package["nagios-plugins-nrpe"], 
                Package["nagios-plugins"]],
   subscribe => File["/etc/nagios/nrpe.cfg"], }

}#end of nrpe class
