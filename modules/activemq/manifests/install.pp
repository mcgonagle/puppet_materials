# Class: activemq::install
#
# This module manages activemq
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
class activemq::install {
  class { "yumrepos::puppetlabs": }

  package{"activemq": 
    ensure => installed,
    require => Class["yumrepos::puppetlabs"], }


}
