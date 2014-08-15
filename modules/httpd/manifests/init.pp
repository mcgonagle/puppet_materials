# Class: httpd
#
# This module manages httpd
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
class httpd (
  $service_enable = 'false',
  $service_ensure = 'stopped',
  $service_hasstatus = 'true',
  $service_hasrestart = 'true') inherits httpd::params {

    include httpd::install, httpd::config, httpd::service

}
