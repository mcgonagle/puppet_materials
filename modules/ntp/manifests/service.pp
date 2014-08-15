# Class: ntp::service
#
# This module manages ntp::service
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
class ntp::service {
  service { "ntpd":
    enable => true,
    ensure => running,
    require => Class["ntp::config"],
  }# end of ntp

}#end of ntp::service
