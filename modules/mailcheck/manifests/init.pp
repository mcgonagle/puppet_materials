# Class: mailcheck
#
# This module manages mailcheck
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
class mailcheck {

  $service_enable = 'false',
  $service_ensure = 'stopped',
  $service_hasstatus = 'true',
  $service_hasrestart = 'true') {

     include mailcheck::install, mailcheck::service

  }


}
