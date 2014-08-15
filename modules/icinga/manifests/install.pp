# Class: icinga::install
#
# This module manages icinga::install
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
class icinga::install {

  package {"icinga": ensure => latest }
  package {"icinga-gui": ensure => latest }
  package {"icinga-doc": ensure => latest }
  package {"icinga-api": ensure => latest }

}
