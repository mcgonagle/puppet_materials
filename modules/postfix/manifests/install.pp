# Class: postfix::install
#
# This module manages postfix::install
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
class postfix::install {
  package { "postfix": ensure => latest }

}#end of class postfix::install
