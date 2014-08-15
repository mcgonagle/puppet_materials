# Class: role::wwwdl
#
# This module manages role::wwwdl
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
class role::wwwdl {
  #class { "jdk": }
  #class { "glassfish": }
  #class { "dlist::web": }
  #class { "maxmind::dlist": }
  #Class["jdk"] -> Class["glassfish"] -> Class["dlist::web"] -> Class["maxmind::dlist"]

  class { "puppet::server": }
  
}#end of role::wwwdl
