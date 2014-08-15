# Class: sysbench
#
# Manages sysbench software 
# Include it to install and run sysbench with default settings
#
# Usage:
# include sysbench

#import "classes/*.pp"
#import "defines/*.pp"
class sysbench {
    package{"sysbench": ensure => latest }
    file{"/etc/ld.so.conf.d/sysbench.lib.conf":
	    content => "/usr/local/lib",
	    owner => "root", group => "root", mode => "0755",
	    require => Package["sysbench"],
	    before => Manhunt::Reload_linker["/etc/ld.so.conf.d/sysbench.lib.conf"], }

    manhunt::reload_linker { "/etc/ld.so.conf.d/sysbench.lib.conf":
    	conf     => "/etc/ld.so.conf.d/sysbench.lib.conf",
    	require  => File["/etc/ld.so.conf.d/sysbench.lib.conf"], }

}#end of class sysbench
