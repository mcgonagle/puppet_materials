# Class: glassfish::service
#
# This module manages glassfish::service
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
class glassfish::service {

  service {"glassfish":
    enable    => "${service_enable}",
    ensure    => "${service_ensure}",
    hasstatus => "${service_hasstatus}",
    hasrestart => "${service_hasrestart}", 
    pattern => "${service_pattern}",
    require => Class["glassfish::config"], }  


}
