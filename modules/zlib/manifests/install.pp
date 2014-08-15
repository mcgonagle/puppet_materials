# Class: zlib::install
#
# This module manages zlib::install
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
class zlib::install {
  package{"zlib": ensure => "latest" }
  package{"zlib-devel": ensure => "latest" }

}
