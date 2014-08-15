# Class: nagios::service
#
# This module manages nagios::service
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
class nagios::service {
    service { "nagios":
         enable  => false,
         ensure  => stopped,
         hasstatus => true,
         hasrestart => true,
         require => Class["nagios"], }
}
