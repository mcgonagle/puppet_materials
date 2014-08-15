# Class: jprofiler
#
# Manages jprofiler J2EE server.
# Include it to install and run java with default settings
#
# Usage:
# include jprofiler


#import "defines/*.pp"
import "classes/*.pp"

class jprofiler {
    
    #require jprofiler::params
    include common

    common::rpm::install::no::yum{"${jprofiler::params::packagename}":
        file => "${jprofiler::params::packagename}",
        module_url => "${jprofiler::params::file_url}",
        destination => "${jprofiler::params::file_destination}",
	alias => "rpm-install-jprofiler", }

   file {"${jprofiler::params::config_xml}":
        ensure => present,
	source => "puppet:///modules/jprofiler/config.xml",
        mode => 0644, owner => root, group => root,
        alias => "jprofiler-config", } 

    common::ldconfig{"/opt/jprofiler5/bin/linux-x64": 
        file => "jprofiler.conf",
	require => File["jprofiler-config"], }

    file{"/etc/init.d/jprofiler":
	ensure => present,
	source => "puppet:///modules/jprofiler/resin-jprofiler",
        mode => 0755, owner => root, group => root,
        alias => "start-resin-jprofiler", } 
		

}
