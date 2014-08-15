# Class: mysql::service
#
# This module manages mysql::service
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
class mysql::service {
   service {"mysql":
        enable  => false,
        ensure  => stopped,
        hasstatus => true,
        hasrestart => true, 
        require => Class["mysql::config"], }

}
