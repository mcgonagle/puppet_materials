# Class: nfs
#
# Manages nfs software 
# Include it to install and run nfs with default settings
#
# Usage:
# include nfs


import "classes/*/*.pp"
import "defines/*.pp"

class nfs {
    include autofs
  
    service { "nfs":
    	ensure      => running,
    	enable      => true,
    	pattern     => "nfs", }

    #munin nfsd plugin monitoring
    #include munin::plugin::nfsd

}#end of class nfs
