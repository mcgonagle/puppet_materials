# Class: ssh2::install
#
# This module manages ssh2::install
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
class ssh2::install {
  package {"libssh2.${architecture}": ensure => latest }
  package {"libssh2-devel.${architecture}": ensure => latest }
}
