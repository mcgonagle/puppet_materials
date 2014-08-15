# Class: mysql
#
# This module manages mysql
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
class mysql (
 $client_package = $mysql::params::client_package,
 $server_package = $mysql::params::server_package
) inherits mysql::params {
  include mysql::install, mysql::config, mysql::service

}
