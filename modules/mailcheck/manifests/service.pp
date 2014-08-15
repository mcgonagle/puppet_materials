# Class: httpd::service
#
# This module manages httpd::service
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
class httpd::service {
      service {"smtp_watcher":
        enable    => "${service_enable}",
        ensure    => "${service_ensure}",
        hasstatus => "${service_hasstatus}",
        hasrestart => "${service_hasrestart}",
        require => Class["httpd::config"], 
      }
      service {"smtp_db_watcher":
        enable    => "${service_enable}",
        ensure    => "${service_ensure}",
        hasstatus => "${service_hasstatus}",
        hasrestart => "${service_hasrestart}",
        require => Class["httpd::config"], 
      }


}
