# Class: resin::service
#
# This module manages resin
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class resin::service {
   service {"resin":
        enable  => false,
        ensure  => stopped,
        hasstatus => true,
        hasrestart => true, 
 	require => Class["resin::config"], }

}#end of resin::service
