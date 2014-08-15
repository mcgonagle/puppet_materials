# Class: rabbitmq::config
#
# This module manages rabbitmq::config
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
class rabbitmq::config {
	file { "/etc/rabbitmq/rabbitmq.config":
		source => "puppet:///modules/rabbitmq/rabbitmq.config",
		owner => "root", group => "root", mode => "0644", 
		require => Class["rabbitmq::install"], }

	# sudo rabbitmqctl add_user mcollective mcollectivepassword

	#sudo rabbitmqctl set_permissions -p / mcollective "^amq.gen-.*" ".*" ".*"	

	#sudo rabbitmqctl delete_user guest

}
