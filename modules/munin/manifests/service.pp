# Class: munin::service
#
# This module manages munin::service
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
class munin::service {
      service {"munin-node":
        enable    => "${service_enable}",
        ensure    => "${service_ensure}",
        hasstatus => "${service_hasstatus}",
        hasrestart => "${service_hasrestart}", 
        require => Class["munin::config"], }

}
