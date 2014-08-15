# Class: autofs
#
# Manages autofs software 
# Include it to install and run autofs with default settings
#
# Usage:
# include autofs

import "classes/*.pp"
class autofs {
    package { "autofs": ensure => latest }
    package { "nfs-utils": ensure => latest }
    package { "portmap": ensure => latest }

    #nagmon::service{"portmap":
    #  enable => true,
    #  ensure => running,
    #  pattern => "portmap",
    #  init_script => "/etc/init.d/portmap",
    #  warn => "1:1",
    #  critical => "1:1",
    #  nrpe_parameter => "-C portmap",  
    #  require => Package["portmap"], }

    service { "portmap":
      enable => true,
      ensure => running,
      pattern => "portmap",
     }# end of portmap service

    #nagmon::service {"autofs":
	    #enable => true,
	    #ensure => running, 
      #pattern => "automount",
      #init_script => "/etc/init.d/portmap",
      #require => Nagmon::Service["portmap"], }

    service { "autofs":
      enable => true,
      ensure => running,
      pattern => "automount",
     }# end of autofs service
}#end of class autofs
