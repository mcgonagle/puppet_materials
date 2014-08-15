# Class: curl::install
#
# This module manages curl::install
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
class curl::install {
  package {"curl": ensure => latest }
  package {"curl-devel": ensure => latest }

}
