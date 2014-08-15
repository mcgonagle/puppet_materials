# Class: autofs::service
#
# This module manages autofs
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
class autofs::service {

    service { "portmap":
      enable => true,
      ensure => running,
      pattern => "portmap",
     }# end of portmap service


    service { "autofs":
      enable => true,
      ensure => running,
      pattern => "automount",
     }# end of autofs service

}
