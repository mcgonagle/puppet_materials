# Class: rsyslog
#
# Manages rsyslog software 
# Include it to install and run rsyslog with default settings
#
# Usage:
# include rsyslog


import "classes/*.pp"
#import "defines/*.pp"

class rsyslog {
    package {"rsyslog": ensure => "latest" }

    file {"/etc/rsyslog.conf":
      #content => template("rsyslog/rsyslog.conf.erb"),
      source => "puppet:///modules/rsyslog/rsyslog.conf",
      owner => "root", group => "root", mode => "0644", 
      require => Package["rsyslog"], }

    file {"/etc/rsyslog.d":
      ensure => directory,
      owner => "root", group => "root", mode => "0755",
      require => [ Package["rsyslog"], File["/etc/rsyslog.conf"] ], }
 
    service { "rsyslog":
      enable => true,
      ensure => running,
      hasstatus => true,
      require => [ Package["rsyslog"], 
                   File["/etc/rsyslog.conf"], 
                   File["/etc/rsyslog.d"] ], }

     @@nagios_service { "check_rsyslogd_proc ${hostname}":
  	ensure => present,
  	use => "generic-service",
  	host_name => "${hostname}",
  	check_command => "check_nrpe!check_rsyslogd_proc",
  	name => "check_rsyslogd_proc ${hostname}",
  	service_description => "check_rsyslogd_proc",
  	target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  	require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
  	notify => Service["nagios"], }    
    

}#end of class rsyslog
