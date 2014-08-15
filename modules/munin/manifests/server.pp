# Class: munin::server
#
# This module manages munin::server
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
class munin::server {

	class {"munin::server::install": }
	class {"munin::server::config": }
	class {"munin": 
    service_enable => 'true',
    service_ensure => 'running', }

  Class["munin::server::install"] -> Class["munin::server::config"] -> Class["munin"]

  

}
