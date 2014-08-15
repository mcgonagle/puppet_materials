# Class: hosts
#
# This class installs uses the puppet's stored configs to dynamically create
# an /etc/hosts file on a host.
#
# Parameters:
#
# Actions:
# Create a dynamic /etc/hosts file containing host entries for all the other 
# puppet clients.
#
# Requires:
#
# Sample Usage:
#  include hosts
#

import "classes/*.pp"

class hosts {

#Host collect definition. Notice, that it is above the actual host definitions.
#this is an example of 

  if $datacenter == "waltham" {
    include hosts::waltham
  }

  @@host { $hostname: 
   ip => $ipaddress, 
   host_aliases => [ $fqdn ],
   ensure => 'present', }

  Host <<||>>

}#end of class hosts
