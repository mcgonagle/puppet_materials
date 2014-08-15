# Class: ocsinventory::install
#
# This module manages ocsinventory
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
class ocsinventory::install {
  package {"ocsinventory-agent": ensure => installed }


}
