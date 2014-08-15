# Class: puppet::server::config
#
# This module manages puppet::server::config
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
class puppet::server::config {
	file {"/etc/puppet/rack":
	  ensure => directory,
	  owner => "puppet", group => "puppet", mode => "0755", }

	file {"/etc/puppet/rack/puppetmaster":
	  ensure => directory,
	  owner => "puppet", group => "puppet", mode => "0755",
	  require => File["/etc/puppet/rack"], }

	file {"/etc/puppet/rack/puppetmaster/public":
	  ensure => directory,
	  owner => "puppet", group => "puppet", mode => "0755",
	  require => File["/etc/puppet/rack/puppetmaster"], }

	file {"/etc/puppet/rack/puppetmaster/tmp":
	  ensure => directory,
	  owner => "puppet", group => "puppet", mode => "0755",
	  require => File["/etc/puppet/rack/puppetmaster"], }



}
