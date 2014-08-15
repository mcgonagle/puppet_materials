# Class: rabbitmq::service
#
# This module manages rabbitmq::service
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
class rabbitmq::service {

    service {"rabbitmq-server":
        enable    => "${service_enable}",
        ensure    => "${service_ensure}",
        hasstatus => "${service_hasstatus}",
        hasrestart => "${service_hasrestart}", 
        require => Class["rabbitmq::config"], }


}
