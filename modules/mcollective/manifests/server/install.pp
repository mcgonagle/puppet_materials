# Class: mcollective::server::install
#
# This module manages mcollective::server::install
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
class mcollective::server::install {
	package { 'mcollective': ensure => '1.0.1-1.el5' }
	package { 'mcollective-common': ensure => '1.0.1-1.el5' }

	package { 'rubygem-stomp': ensure => '1.1.8-1.el5' }

}
