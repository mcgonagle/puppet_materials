# Class: hosts
#
# This module manages hosts
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
class hosts {

  @@host { "${hostname}": 
   ip => "${ipaddress}", 
   host_aliases => [ "${fqdn}" ],
   ensure => 'present', }

  Host <<||>>

}#end of class hosts
