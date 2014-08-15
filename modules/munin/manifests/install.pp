# Class: munin::install
#
# This module manages munin::install
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
class munin::install {
  package{"munin-node": ensure => latest }


}
