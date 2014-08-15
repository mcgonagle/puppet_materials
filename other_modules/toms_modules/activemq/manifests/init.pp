# Class: activemq
#
# Manages activemq software 
# Include it to install and run activemq with default settings
#
# Usage:
# include activemq


import "classes/*.pp"
#import "defines/*.pp"

class activemq {  
    require sun-java
    #include java::sun
    package{"activemq": ensure => latest }
    
   
    file {"/etc/activemq/activemq.xml":
        source => ["puppet:///modules/activemq/activemq.xml.${hostname}",
		               "puppet:///modules/activemq/activemq.xml.${role}",
		               "puppet:///modules/activemq/activemq.xml" ],
        owner => "root", group => "root", mode => "0744",
        require => Package["activemq"],}

    file {"/etc/activemq/activemq-wrapper.xml":
        source => "puppet:///modules/activemq/activemq-wrapper.xml",
        owner => "root", group => "root", mode => "0744",
        require => Package["activemq"],}

    nagmon::service { "activemq":
 	      enable => true,
 	      ensure => running,
        pid_file => "/var/run/activemq/activemq.pid",
        init_script => "/etc/init.d/activemq",
        warn => "1:1",
        critical => "1:1",
        nrpe_parameter => "-C tanukiwrapper",
	      require => [ File["/etc/activemq/activemq-wrapper.xml"], 
	                   File["/etc/activemq/activemq.xml"]], }

}#end of class activemq
