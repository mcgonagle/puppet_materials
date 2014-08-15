# Class: memcached::install
#
# This module manages memcache
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
class memcached::install {
	package{"memcached": 
		ensure => latest,
		notify => [ File["/etc/init.d/memcached"],
                File["/etc/sysconfig/memcached"]] }

	package{"perl-Cache-Memcached": ensure => latest }

	file {"/etc/init.d/memcached":
		ensure => absent, }

	file {"/etc/sysconfig/memcached":
		ensure => absent, }

}
