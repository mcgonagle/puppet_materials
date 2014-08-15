# Class: ntp::install
#
# This module manages ntp
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
class ntp::install {
  package{"ntp": ensure => latest }

}#end of ntp::install
