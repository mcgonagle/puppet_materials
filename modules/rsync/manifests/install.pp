# Class: rsync::install
#
# This module manages rsync::install
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
class rsync::install {
  package{"rsync": ensure => installed }

}
