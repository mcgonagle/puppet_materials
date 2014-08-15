# Class: rstatd
#
# Manages rstatd software 
# Include it to install and run rstatd with default settings
#
# Usage:
# include rstatd

class rstatd {
    package{"rusers-server": ensure => latest }    
    service{"rstatd": 
      enable => true,
      ensure => running,
      pattern => "rpc.rstatd",
      require => Package["rusers-server"], }

}#end of class rstatd
