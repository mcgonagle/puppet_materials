# Class: rabbitmq::install
#
# This module manages rabbitmq::install
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
class rabbitmq::install {

	package { 'erlang': ensure => 'R12B-5.12.el5.rf' }
	package { 'rabbitmq-server': 
		ensure => '2.4.1-1',
		require => Package["erlang"], } 

	package { 'rabbitmq-plugin-stomp': 
		ensure => '2.4.1-0.201104081055', 
		require => Package["rabbitmq-server"], } 

	package { 'rabbitmq-plugin-amqp': 
		ensure => '2.4.1-0.201104081007',
		require => Package["rabbitmq-server"], } 

}
