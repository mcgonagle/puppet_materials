# Class: ntp
#
# Manages ntp server.
# Include it to install and run ntp with default settings
#
# Usage:
# include ntp

import "classes/*.pp"
class ntp {
   package { "ntp": ensure => latest }

   file { "/etc/ntp.conf":
      content => template("ntp/ntp.conf.erb"),
      owner => "root", group => "root", mode => "0644",
      require => Package["ntp"], }
  
   file { "/etc/sysconfig/ntpd":
      source => "puppet:///modules/ntp/sysconfig/ntpd",
      owner => "root", group => "root", mode => "0644",
      require => Package["ntp"], }

   file { "/etc/logrotate.d/ntpd":
      source => "puppet:///modules/ntp/logrotate.d/ntpd",
      owner => "root", group => "root", mode => "0644",
      require => Package["ntp"], }

    nagmon::service {"ntpd": 
      enable => true, 
      ensure => running,
      init_script => "/etc/init.d/ntpd",
      pid_file => "/var/run/ntpd.pid",
      warn => "1:1",
      critical => "1:1",
      nrpe_parameter => "-C ntpd",  
      require => [ File["/etc/ntp.conf"], File["/etc/sysconfig/ntpd"] ],
      subscribe => [ File["/etc/ntp.conf"],File["/etc/sysconfig/ntpd"] ], }

}#end of class ntp
