# Class: rabbitmq
#
# This module manages rabbitmq
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
class rabbitmq (
  $service_enable = 'false',
  $service_ensure = 'stopped',
  $service_hasstatus = 'true',
  $service_hasrestart = 'true') inherits rabbitmq::params {

	class { "rabbitmq::install": }
	class { "rabbitmq::config": }
	class { "rabbitmq::service": }

	
	Class["rabbitmq::install"] -> Class["rabbitmq::config"] -> Class["rabbitmq::service"]


}
