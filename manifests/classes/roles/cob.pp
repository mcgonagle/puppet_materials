# Class: role::cob
#
# This module manages role::cob
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
class role::cob {
 include cobblerd
 #include nagios::server
 class { 'icinga': }
 class { 'activemq': }
 #class { 'ocsinventory::server': }

}#end of role::cob
