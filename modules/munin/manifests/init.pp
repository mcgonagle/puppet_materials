# Class: munin
#
# This module manages munin
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
class munin ( 
  $service_enable = 'false',
  $service_ensure = 'stopped',
  $service_hasstatus = 'true',
  $service_hasrestart = 'true') inherits munin::params {

  class {"munin::install": }
  class {"munin::config": }
  class {"munin::service": }

  Class["munin::install"] -> Class["munin::config"] -> Class["munin::service"]


}
