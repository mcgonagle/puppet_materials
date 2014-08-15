# Class: logrotate
#
# Installs and manages logrotate.
# Include it to install and run logrotate with default settings
#
# Usage:
# include
#http://projects.puppetlabs.com/projects/1/wiki/Logrotate_Patterns

#import the defines and classes subdirectories
import "defines/*.pp"

class logrotate {

    package { "logrotate": ensure => latest, }

    file { "/etc/logrotate.d":
      ensure => directory,
      owner => "root", group => "root", mode => "0755",
      require => Package["logrotate"], }

    file {"/etc/logrotate.conf":
	source => "puppet:///modules/logrotate/logrotate.conf",
	owner => "root", group => "root", mode => "0644", 
	require => File["/etc/logrotate.d"], }
}
