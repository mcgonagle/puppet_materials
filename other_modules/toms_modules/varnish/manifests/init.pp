# Class: varnish
#
# Manages varnish software 
# Include it to install and run varnish with default settings
#
# Usage:
# include varnish


#import "classes/*.pp"
#import "defines/*.pp"

class varnish {
    package {"varnish": ensure => latest }
    service {"varnish": 
      ensure => running,
      enable => true, 
      require => Package["varnish"], }

}#end of class varnish
