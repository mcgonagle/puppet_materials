# Class: mcollective::server
#
# Manages mcollective::server software 
# Include it to install and run mcollective with default settings
#
# Usage:
# include mcollective::server

class mcollective::server inherits mcollective {
    file{"/usr/libexec/mcollective/mcollective/":
        ensure => directory,
        owner => "root", group => "root", mode => "0644",
	require => Package["mcollective"], }

}#end of class mcollective::server
