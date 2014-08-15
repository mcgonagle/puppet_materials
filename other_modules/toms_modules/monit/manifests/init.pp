# Class: monit
#
# Manages monit software 
# Include it to install and run monit with default settings
#
# Usage:
# include monit


import "classes/*.pp"
import "defines/*.pp"

class monit {
    package{"monit": ensure => latest}
    file{"/etc/monit.conf":
	    content => template("monit/monit.conf.erb"),
	    owner => "root", group => "root", mode => "0700", 
	    require => Package["monit"], }

    service{"monit": 
 	    enable => true,
	    ensure => running, 
	    subscribe => File["/etc/monit.conf"], }
}#end of class monit
