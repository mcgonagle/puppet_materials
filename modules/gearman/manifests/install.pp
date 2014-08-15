# Class: gearman
#
# This module manages gearman
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
class gearman::install {
  package {"gearmand":
    ensure => "latest", }
  
  package {"libgearman":
    ensure => "latest", }

  package {"libgearman-devel":
    ensure => "latest", }
     

}
