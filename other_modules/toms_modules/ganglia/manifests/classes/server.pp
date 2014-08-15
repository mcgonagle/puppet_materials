class ganglia::server inherits ganglia {
  include httpd
  include php

  package { "rrdtool-devel": ensure => latest }
  package { "ganglia-gmetad": ensure => latest }
  package { "ganglia-web": ensure => latest }
  package { "libpng": ensure => latest }

  file { "/etc/ganglia/gmetad.conf":
  	content => template("ganglia/gmetad.conf.erb"),
  	owner => "root", group => "root", mode => "0544",
  	require => [ Package["ganglia-gmetad"], File["/etc/ganglia"] ], }

  #the gmetad process has a dependency for  librrd.so.4, I am solving it by hardcoding 
  #export LD_LIBRARY_PATH=/opt/zenoss/lib/
  #into the startup script to use the librrd.so.4 provided by zenoss

  file {"/etc/init.d/gmetad":
  	content => template("ganglia/gmetad.erb"),
  	owner => "root", group => "root", mode => "0755",
  	require => [Package["ganglia-gmetad"], File["/etc/ganglia"]], }

  service { "gmetad":
   	enable => true, 
   	ensure => running,
   	subscribe => File["/etc/ganglia/gmetad.conf"],
   	require => [File["/etc/ganglia/gmetad.conf"], File["/etc/init.d/gmetad"]], }

  @@nagios_service { "check_gmetad_proc ${hostname}":
  	ensure => present,
  	use => "generic-service",
  	host_name => "${hostname}",
  	check_command => "check_nrpe!check_gmetad_proc",
  	name => "check_gmetad_proc ${hostname}",
  	service_description => "check_gmetad_proc",
  	target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  	require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
  	notify => Service["nagios"], }    

}#end of ganglia::server
